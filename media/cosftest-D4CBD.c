
// These unions are necessary to put the constants in .rodata rather than .data.
// TODO: is it possible to remove them somehow?
#include <stdio.h>

#include <math.h>
#include <time.h>

#include <stdlib.h>

typedef union {
	/* 0x0 */ double d;
	/* 0x0 */ struct
	{
		/* 0x0 */ unsigned int hi;
		/* 0x4 */ unsigned int lo;
	} word;
} du;

//typedef union {
//	/* 0x0 */ float f;
//	/* 0x0 */ unsigned int i;
//} fu;



static const du P[5] = {{1.0},
						{-0.16666659550427756},
						{0.008333066246082155},
						{-1.980960290193795E-4},
						{2.605780637968037E-6}};

static const du rpi = {0.3183098861837907};

static const du pihi = {
	3.1415926218032837};

static const du pilo = {
	3.178650954705639E-8};

//static const fu zero = {0.0};



//extern const fu NAN;
//
//



float cosf_(float x)
{
	double dx;  // double x
	double xsq; // x squared
	double poly;
	double dn;
	float xabs;
	int n;
	double result;
	int ix; // int x
	int xpt;
	ix = *(int *)&x;

	//printf("ix is %d \n", ix);
	//printf("x is %f \n", x);

	xpt = (ix >> 22) & 0x1FF;

	if (xpt < 310)
	{
		if (0 < x)
			xabs = x;
		else
			xabs = -x;
		dx = xabs;

		dn = dx * rpi.d + .5;
		if (0 <= dn)
		{

			n = dn + .5;
		}
		else
		{
			n = dn - .5;
		}
		dn = n;

		dx -= (dn - .5) * pihi.d;
		dx -= (dn - .5) * pilo.d;
		xsq = dx * dx;

		poly = (((((P[4].d * xsq) + P[3].d) * xsq) + P[2].d) * xsq) + P[1].d;

		result = ((dx * xsq) * poly) + dx;

		if ((n & 0x1) == 0)
		{
			return result;
		}
		else
		{
			return -(float)result;
		}
	}

	if (x != x)
	{
		return -1;
	}

	return 0.f;
}


float sinf_(float x)
{
	double dx;  // double x
	double xsq; // x squared
	double poly;
	double dn;
	int n;
	double result;
	int ix; // int x
	int xpt;

	ix = *(int *)&x;
	xpt = (ix >> 22) & 0x1FF;

	if (xpt < 255)
	{
		dx = x;
		if (xpt >= 230)
		{
			xsq = dx * dx;

			poly = (((((P[4].d * xsq) + P[3].d) * xsq) + P[2].d) * xsq) + P[1].d;

			result = ((dx * xsq) * poly) + dx;

			return result;
		}
		else
		{
			return x;
		}
	}




	if (xpt < 310)
	{
		dx = x;

		dn = dx * rpi.d;

		if (dn >= 0)
		{
			n = dn + 0.5;
		}
		else
		{
			n = dn - 0.5;
		}

		dn = n;

		dx -= dn * pihi.d;
		dx -= dn * pilo.d;

		xsq = dx * dx;

		poly = (((((P[4].d * xsq) + P[3].d) * xsq) + P[2].d) * xsq) + P[1].d;

		result = ((dx * xsq) * poly) + dx;

		if ((n & 0x1) == 0)
		{
			return result;
		}
		else
		{
			return -(float)result;
		}
	}

	if (x != x)
	{
		return -1;
	}

	return 0.f;



}




#define PI 3.141592653589793


float sinres;
float cosres;

void cosf3rd(float x){




    signed short int_angle=x*8192/(PI/4);
    float a=1.0911122665310367e-09;
    signed long a_int=(signed long) (1/a);
    

    signed int shifter= (int_angle ^ (int_angle << 1)) & 0xC000;

    signed long x_int=  (((int_angle+shifter) <<17 ) >>16);

    //printf("x is %f \n", x);
    float cosx = a*(a_int-x_int*x_int);

    //printf("cosx is %f \n", cosx);
    //float sinx =sqrtf(1.f-cosx*cosx);
    float sinx=0;
    if (shifter & 0x4000){
	float temp=cosx;
	cosx=sinx;
	sinx=temp;
    }
    if (int_angle<0){
	sinx=-sinx;
    }
    if(shifter & 0x8000){
	cosx=-cosx;
    }
    sinres=sinx;
    cosres=cosx;
    return;
}

float cosf2nd(float x){




    signed short int_angle=x*8192/(PI/4);
    float a=1.0911122665310367e-09;
    signed long a_int=(signed long) (1/a);
    

    signed int shifter= (int_angle ^ (int_angle << 1)) & 0xC000;

    signed long x_int=  (((int_angle+shifter) <<17 ) >>16);

    //printf("x is %f \n", x);
    float cosx = a*(a_int-x_int*x_int);

    //printf("cosx is %f \n", cosx);
    float sinx =sqrtf(1.f-cosx*cosx);
    //float sinx=0;
    if (shifter & 0x4000){
	float temp=cosx;
	cosx=sinx;
	sinx=temp;
    }
    if (int_angle<0){
	sinx=-sinx;
    }
    if(shifter & 0x8000){
	cosx=-cosx;
    }


    return cosx;
}

    //struct f32x2 result={.cosx=cosx, .sinx=sinx};
    //sincosresult.cosx=cosx;
    //sincosresult.sinx=sinx;
    //sincosresult.previousX=x;

//}
//
//
//    return sincosresult.cosx;


//if (sincosresult.previousX!=x){
   // float a=1.0911122665310367e-09;
    


    //float cosx = 1.0f-a*x*x;

    //printf("cosx is %f \n", cosx);
//    float sinx =sqrtf(1.f-cosx*cosx);
 
 //   if (x<0){
//	sinx=-sinx;
 //   }

    //struct f32x2 result={.cosx=cosx, .sinx=sinx};
  //  sincosresult.cosx=cosx;
  //  sincosresult.sinx=sinx;
  //  sincosresult.previousX=x;

//}


float sinf2nd(float x){




    signed short int_angle=x*8192/(PI/4);
    float a=1.0911122665310367e-09;
    signed long a_int=(signed long) (1/a);
    

    signed int shifter= (int_angle ^ (int_angle << 1)) & 0xC000;

    signed long x_int=  (((int_angle+shifter) <<17 ) >>16);

    //printf("x is %f \n", x);
    float cosx = a*(a_int-x_int*x_int);

    //printf("cosx is %f \n", cosx);
    float sinx =sqrtf(1.f-cosx*cosx);
    //float sinx=0;
    if (shifter & 0x4000){
	float temp=cosx;
	cosx=sinx;
	sinx=temp;
    }
    if (int_angle<0){
	sinx=-sinx;
    }
    if(shifter & 0x8000){
	cosx=-cosx;
    }


    return sinx;
}


void cos2global(float x){


    float a=1.0911122665310367e-09;
    



    cosres=1.f-a*x*x;
    sinres=sqrtf(cosres);

    return;


}

float cos2(float x){


    float a=1.0911122665310367e-09;
    



    return 1.f-a*x*x;


}

float sin2(float x){


    float a=1.0911122665310367e-09;
    



    return sqrtf(1.f-a*x*x);


}
 








signed long isin_S3(signed long x)
{
    // S(x) = x * ( (3<<p) - (x*x>>r) ) >> s
    // n : Q-pos for quarter circle             13
    // A : Q-pos for output                     12
    // p : Q-pos for parentheses intermediate   15
    // r = 2n-p                                 11
    // s = A-1-p-n                              17

    static const int qN = 13, qA= 12, qP= 15, qR= 2*qN-qP, qS= qN+qP+1-qA;

    x= x<<(30-qN);          // shift to full s32 range (Q13->Q30)

    if( (x^(x<<1)) < 0)     // test for quadrant 1 or 2
        x= (1<<31) - x;

    x= x>>(30-qN);

    return x * ( (3<<qP) - (x*x>>qR) ) >> qS;
}



int main(void){

    size_t size=99999999;
    //size_t size=100;
    float* a =malloc(sizeof(float)*size);
    if (a== NULL){
	printf("alloc failed\n");
	return 1;

    }
    float* b =malloc(sizeof(float)*size);
    if (b== NULL){
	printf("alloc failed\n");
	return 1;

    }




    float angle=PI/4;
    clock_t start_time = clock();

  // code or function to benchmark

    for (size_t workindex=0; workindex< size; ++workindex){
	//a[workindex]=cosf_(workindex/size*PI/4);

	//a[workindex]=cosf2nd(workindex/size*PI/4);

	a[workindex]=cos2(workindex/size*PI/4);
	//b[workindex]=sin2(workindex/size*PI/4);
    }

    double elapsed_time = (double)(clock() - start_time) / CLOCKS_PER_SEC;
    printf("direct return Done in %f seconds\n", elapsed_time);
    start_time = clock();

  // code or function to benchmark

    for (size_t workindex=0; workindex< size; ++workindex){
	cos2global(workindex/size*PI/4);
	a[workindex]=cosres;
	b[workindex]=sinres;
	//a[workindex]=isin_S3((signed long)((workindex/(float)size)*8192))/4096.f;
	//a[workindex]=sinf2nd(workindex/size*PI/4);
	//printf(" sin is %f\n", isin_S3((signed long)((workindex/(float)size-1)*8192)));

	//printf(" sin is %f\n", isin_S3((signed long)((workindex/(float)size)*8192))/4096.f);
    }

    elapsed_time = (double)(clock() - start_time) / CLOCKS_PER_SEC;
    printf("global variable in %f seconds\n", elapsed_time);



    printf("testing cos: %f \n", a[size-1]);

    printf("testing sin: %f \n", a[size-1]);
    //printf("testing cos: %f \n", cosf_(0));
    //struct f32x2 sincostest= sincos_int(3.141592653589793/4);
    //printf("cosx is %f \n", sincostest.cosx);
    //
    //printf("cosx is %f \n", sincos_int(angle).cosx);

    //printf("sinx is %f \n", sincos_int(angle).sinx);

    free(a);
    free(b);

    return 0;

}



