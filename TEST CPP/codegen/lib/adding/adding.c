/*
 * adding.c
 *
 * Code generation for function 'adding'
 *
 * C source code generated on: Sat Oct 05 12:45:37 2013
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "adding.h"

/* Function Definitions */

/*
 * function [a]=adding(e,t)
 */
void adding(const real_T e[6], const real_T t[6], real_T a[9])
{
  int32_T i0;
  int32_T i1;
  int32_T i2;

  /* 'adding:3' a=e*t; */
  for (i0 = 0; i0 < 3; i0++) {
    for (i1 = 0; i1 < 3; i1++) {
      a[i0 + 3 * i1] = 0.0;
      for (i2 = 0; i2 < 2; i2++) {
        a[i0 + 3 * i1] += e[i0 + 3 * i2] * t[i2 + (i1 << 1)];
      }
    }
  }
}

/* End of code generation (adding.c) */
