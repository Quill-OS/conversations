
//#include "softfloat.h"
float __wrap___mulsf3( float x, float y);
float __mulsf3( float x, float y);

#include <stdio.h>

#include <stdint.h>
#define f32 float
#define u32 uint32_t
#define s32 int32_t
#define u64 uint64_t



//f32 __aeabi_fmul( f32 x, f32 y) asm("__aeabi_fmul");
//f32 __aeabi_fdiv(f32 x, f32 y ) asm("__aeabi_fdiv");



f32 __wrap___mulsf3( f32 x, f32 y){
    union {
    u32 i;
    f32 f;
    }xu;
    xu.f=x;
    union {
    u32 j;
    f32 f;

    }yu;
    yu.f=y;

    u32 a =xu.i & (1<<31);//get sign of x
    u32 b =yu.j & (1<<31);//get sign of y

    s32 exponentx=(xu.i ) &( 0xff<<23);
    s32 exponenty=(yu.j) &(0xff<<23);
    s32 combined_exponent =(exponentx- (127<<23)) +exponenty;

    u32 i=(xu.i & 0x7fffff); //should be explicit bits of mantissa
    u32 j=(yu.j & 0x7fffff);
    //i=i<<4;
    //j=j<<5;
    u32 mantissa=i+j+(((u64)(i<<4)*(u64)(j<<5))>>32);
    mantissa =mantissa +  (1<< 23) ;
    s32 clz=__builtin_clz(mantissa);
    printf("mulsf3  got called!\n");

    s32 shift=8-clz;

    mantissa= shift>=0 ? mantissa>>shift: mantissa<<-shift;

    mantissa= mantissa & ((1<<23)-1);
    u32 exponent=(combined_exponent+(shift<<23));
    u32 sign= a^b;
    union{
    f32 f;
    u32 k;
    }result;
    result.k= sign |exponent | mantissa;

    return combined_exponent<=(1<<23)? 0.0:result.f ;

}


f32 fmul(f32 x, f32 y){
    printf("fmul call!\n");
    return x*y;
}

/*
f32 __aeabi_fdiv(f32 x, f32 y ) {
    union {
    u32 i;
    f32 f;
    }xu;
    xu.f=x;
    union {
    u32 j;
    f32 f;

    }yu;
    yu.f=y;
    u64 i=((xu.i & ((1<<23)-1))|(1<<23));    
    u32 j=((yu.j & ((1<<23)-1))|(1<<23));
    REG_DIVCNT = DIV_64_32; 
    REG_DIV_NUMER = (i<<23);
    REG_DIV_DENOM_L = j;
    s16 shift= i<j ? -1 : 0; 
    u64 m=(xu.i) & (0xff<<23);
    u64 n=(yu.j) & (0xff<<23);
    s32 exponent=m-n+(shift<<23)+(127<<23);
    u32 a =xu.i & (1<<31);//get sign of x
    u32 b =yu.j & (1<<31);//get sign of y
    u32 sign=a^b;
    if ((exponent<=(1<<23))){
    while(REG_DIVCNT & DIV_BUSY);
    return 0.0;
    }
    while(REG_DIVCNT & DIV_BUSY);
    u32 mantissa=REG_DIV_RESULT_L;
    mantissa=shift>=0 ? mantissa>>(shift) : mantissa<<-shift;
    mantissa=mantissa & ((1<<23)-1);
    xu.i= sign | exponent | mantissa;
    return xu.f;
}
*/

int main(void){
    printf("result: %f \n", __mulsf3(2.0,4.0));
    printf("result: %f \n", fmul(2.0,4.0));
    return 0;

}


