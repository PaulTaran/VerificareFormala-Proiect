
I1 = ExamplePoly.randVrep;   
V = [0 0; 1 0; 0 1];
I1 = Star(V', I1.A, I1.b); % star set 1

I2 = ExamplePoly.randVrep;  
V = [1 1; 1 0; 0 1];
I2 = Star(V', I2.A, I2.b); % star set 2

I21 = I2.convexHull(I1);

figure;
Star.plot(I21); 
hold on;
Star.plot(I1);
hold on;
Star.plot(I2);

