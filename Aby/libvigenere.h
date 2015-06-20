//
// MATLAB Compiler: 4.18.1 (R2013a)
// Date: Thu Sep 05 11:19:32 2013
// Arguments: "-B" "macro_default" "-v" "-W" "cpplib:libvigenere" "-T"
// "link:lib" "encrypt" "decrypt" 
//

#ifndef __libvigenere_h
#define __libvigenere_h 1

#if defined(__cplusplus) && !defined(mclmcrrt_h) && defined(__linux__)
#  pragma implementation "mclmcrrt.h"
#endif
#include "mclmcrrt.h"
#include "mclcppclass.h"
#ifdef __cplusplus
extern "C" {
#endif

#if defined(__SUNPRO_CC)
/* Solaris shared libraries use __global, rather than mapfiles
 * to define the API exported from a shared library. __global is
 * only necessary when building the library -- files including
 * this header file to use the library do not need the __global
 * declaration; hence the EXPORTING_<library> logic.
 */

#ifdef EXPORTING_libvigenere
#define PUBLIC_libvigenere_C_API __global
#else
#define PUBLIC_libvigenere_C_API /* No import statement needed. */
#endif

#define LIB_libvigenere_C_API PUBLIC_libvigenere_C_API

#elif defined(_HPUX_SOURCE)

#ifdef EXPORTING_libvigenere
#define PUBLIC_libvigenere_C_API __declspec(dllexport)
#else
#define PUBLIC_libvigenere_C_API __declspec(dllimport)
#endif

#define LIB_libvigenere_C_API PUBLIC_libvigenere_C_API


#else

#define LIB_libvigenere_C_API

#endif

/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_libvigenere_C_API 
#define LIB_libvigenere_C_API /* No special import/export declaration */
#endif

extern LIB_libvigenere_C_API 
bool MW_CALL_CONV libvigenereInitializeWithHandlers(
       mclOutputHandlerFcn error_handler, 
       mclOutputHandlerFcn print_handler);

extern LIB_libvigenere_C_API 
bool MW_CALL_CONV libvigenereInitialize(void);

extern LIB_libvigenere_C_API 
void MW_CALL_CONV libvigenereTerminate(void);



extern LIB_libvigenere_C_API 
void MW_CALL_CONV libvigenerePrintStackTrace(void);

extern LIB_libvigenere_C_API 
bool MW_CALL_CONV mlxEncrypt(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);

extern LIB_libvigenere_C_API 
bool MW_CALL_CONV mlxDecrypt(int nlhs, mxArray *plhs[], int nrhs, mxArray *prhs[]);


#ifdef __cplusplus
}
#endif

#ifdef __cplusplus

/* On Windows, use __declspec to control the exported API */
#if defined(_MSC_VER) || defined(__BORLANDC__)

#ifdef EXPORTING_libvigenere
#define PUBLIC_libvigenere_CPP_API __declspec(dllexport)
#else
#define PUBLIC_libvigenere_CPP_API __declspec(dllimport)
#endif

#define LIB_libvigenere_CPP_API PUBLIC_libvigenere_CPP_API

#else

#if !defined(LIB_libvigenere_CPP_API)
#if defined(LIB_libvigenere_C_API)
#define LIB_libvigenere_CPP_API LIB_libvigenere_C_API
#else
#define LIB_libvigenere_CPP_API /* empty! */ 
#endif
#endif

#endif

extern LIB_libvigenere_CPP_API void MW_CALL_CONV encrypt(int nargout, mwArray& ciphertext, const mwArray& plaintext, const mwArray& key);

extern LIB_libvigenere_CPP_API void MW_CALL_CONV decrypt(int nargout, mwArray& plaintext, const mwArray& ciphertext, const mwArray& key);

#endif
#endif
