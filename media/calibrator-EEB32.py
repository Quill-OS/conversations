import numpy as np
np.set_printoptions(suppress=True)
np.set_printoptions(precision=4)

x_max=1435
y_max=1919

xmax_new=1024  
ymax_new=758


#measurement data for the two coordinates x~x1 and y~x2
x1=[0, #bottom left
x_max,   #top left
x_max, #top right
0] #bottom right
x2=[0,#bottom left
0, #top left
y_max, #top right
y_max] #bottom right

#expected output for screen coordinate x
y=[0,
0,
xmax_new,
xmax_new]


#do linear regression curve fitting and store coefficients and offsets in beta_x

X=np.array([x1,x2, np.ones(len(x1))]).T

beta_x=np.dot(np.linalg.inv(X.T@X)@X.T,y)



#expected output for screen coordinate y
y=[ymax_new, 
0,
0,
ymax_new]

#do linear regression curve fitting and store coefficients and offsets in beta_y

X=np.array([ x1,x2, np.ones(len(x1))]).T
print(X.shape)
print(np.shape(y))
beta_y=np.dot(np.linalg.inv(X.T@X)@X.T,y)

#construct matrix and offset vector

matrix=np.array([[beta_x[0], beta_x[1]],[beta_y[0],beta_y[1]]])
offset=np.array([beta_x[2],beta_y[2]])



#do tests
def transform(matrix,offset, x,y):
    return np.dot(matrix,np.array([x,y]))+offset

print("Testing (0,0), expected is (0,ymax_new): \n",transform(matrix, offset, 0,0))
print("Testing (x_max,0), expected is (0,0): \n",transform(matrix, offset, x_max,0))
print("Testing (0,y_max), expected is (xmax_new,ymax_new): \n",transform(matrix, offset, 0,y_max))
print("Testing (x_max,y_max), expected is (xmax_new,0): \n",transform(matrix, offset, x_max,y_max))


print("Expected transformation matrix: ", np.around(matrix[0,0], decimals=3), np.around(matrix[0,1],decimals=3), np.around(offset[0]/xmax_new, decimals=3), np.around(matrix[1,0],decimals=3),np.around(matrix[1,1], decimals=3),np.around(offset[1]/ymax_new, decimals=3), 0,0,1)
