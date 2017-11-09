#include <stdio.h>
#include <cstdlib>
#include <ctime>
#include <cmath>

#if defined(WIN32) || defined(_WIN32)
#include <windows.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif
	
	void swift_api_main() {
#if defined(WIN32) || defined(_WIN32)
		if (AttachConsole(ATTACH_PARENT_PROCESS)) {
			freopen("CONOUT$", "w", stdout);
			freopen("CONOUT$", "w", stderr);
		}
#endif
		
		srand(time(0x0));
	}
	
	void swift_api_exit() {
		exit(1);
	}
	
	int swift_api_rand() {
		return rand();
	}

	void swift_api_srand(unsigned int value) {
		srand(value);
	}
	
	double swift_api_sqrt(double value) {
		return sqrt(value);
	}
	
	double swift_api_pow(double base, double exponent) {
		return pow(base, exponent);
	}
	
	double swift_api_sin(double value) {
		return sin(value);
	}
	
	double swift_api_cos(double value) {
		return cos(value);
	}
	
	double swift_api_tan(double value) {
		return tan(value);
	}
	
	double swift_api_asin(double value) {
		return asin(value);
	}
	
	double swift_api_acos(double value) {
		return acos(value);
	}
	
	double swift_api_atan(double value) {
		return atan(value);
	}
	
	double swift_api_atan2(double y, double x) {
		return atan2(y, x);
	}
	
	double swift_api_log(double value) {
		return log(value);
	}
	
	double swift_api_log2(double value) {
		return log2(value);
	}
	
	
	double swift_api_log10(double value) {
		return log10(value);
	}
	
	double swift_api_exp(double value) {
		return exp(value);
	}
	
#ifdef __cplusplus
}
#endif
