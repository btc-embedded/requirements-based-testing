from btc_tests import run_mil_tests, run_sil_tests

if __name__ == "__main__":
    success = run_mil_tests()
    if success:
        success = run_sil_tests()
    else:
        print("MIL tests failed. Skipping SIL tests, coverage, etc.")
