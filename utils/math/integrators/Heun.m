clear all
clc
x=input('x=');
y=input('y=');
h=input('h=');
f=inline(input('f=','s'));
l=input('eval f at:');
i=0;c=zeros(1,1);z=0;
 disp('  i       x_i         z_i        y_i')
while(1)
    fprintf('%3i %11.6f %11.6f %11.6f\n',i,x,z,y);
    a=feval(f,x,y);
    z=y+h*a;
    x=h+x;
    yn=y+h*0.5*(feval(f,x,z)+a);
    y=yn;
    z=z;
    i=i+1;
       if( x == l)
           fprintf('%3i %11.6f %11.6f %11.6f\n',i,x,z,y);
        break
    end
end