import os
from datetime import datetime

from btc_embedded import EPRestApi, util


def run_btc_test():
    epx_file = os.path.abspath("test/seat_heating_controller.epx")
    project_name = os.path.basename(epx_file)[:-4]
    work_dir = os.path.dirname(epx_file)
    report_dir = os.path.join(os.path.dirname(work_dir), 'reports')
    # BTC EmbeddedPlatform API object
    ep = EPRestApi()

    # Load a BTC EmbeddedPlatform profile (*.epx) and upgrade it (incl. code generation via TL)
    ep.get(f"openprofile?path={epx_file}", message="Loading profile")
    ep.put('architecturesConvert', {
        'initScript' : os.path.abspath("model/init.m")
    }, message='Upgrading to MIL+SIL project')

    # Execute requirements-based tests on MIL and SIL
    exec_start_time = datetime.now()
    scopes = ep.get('scopes')
    scope_uids = [ scope['uid'] for scope in scopes]
    toplevel_scope_uid = scope_uids[0]
    rbt_exec_payload = {
        'UIDs': scope_uids,
        'data' : {
            'execConfigNames' : [ 'TL MIL', 'SIL' ]
        }
    }
    rbt_response = ep.post('scopes/test-execution-rbt', rbt_exec_payload, message="Executing requirements-based tests")
    rbt_coverage = ep.get(f"scopes/{toplevel_scope_uid}/coverage-results-rbt")
    util.print_rbt_results(rbt_response, rbt_coverage)

    # automatic test generation for MCDC with a timeout of 60 seconds
    vector_gen_settings = {
        'scopeUid'  : toplevel_scope_uid,
        'pllString' : 'MCDC', 
        'engineSettings' : {
            'timeoutSeconds' : 60
        }
    }
    ep.post('coverage-generation', vector_gen_settings, message="Generating vectors")
    b2b_coverage = ep.get(f"scopes/{toplevel_scope_uid}/coverage-results-b2b")

    # B2B TL MIL vs. SIL
    b2b_response = ep.post(f"scopes/{toplevel_scope_uid}/b2b", { 'refMode': 'TL MIL', 'compMode': 'SIL' }, message="Executing B2B test")
    util.print_b2b_results(b2b_response, b2b_coverage)
    
    # Create project report
    report = ep.post(f"scopes/{toplevel_scope_uid}/project-report", message="Creating test report")
    # export project report to a file called 'report.html'
    ep.post(f"reports/{report['uid']}", { 'exportPath': report_dir, 'newName': 'report' })
    # Dump JUnit XML report for GitHub Actions
    util.dump_testresults_junitxml(
        b2b_result=b2b_response,
        rbt_results=rbt_response,
        scopes=scopes,
        test_cases=ep.get('test-cases-rbt'),
        start_time=exec_start_time,
        project_name=project_name,
        output_file=os.path.join(report_dir, 'test_results.xml')
    )

    # Save *.epp
    # ep.put('profiles', { 'path': epx_file }, message="Saving profile")

    print('Finished with workflow.')


# Allows the script to be called directly
# (e.g., "python test_workflow.py")
if __name__ == '__main__':
    run_btc_test()
