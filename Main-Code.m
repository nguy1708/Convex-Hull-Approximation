n = 1000;

%initialize variables needed
h = 0.1;
e = 0.1;

%Take the input value and create input amount of points
points = rand(n,2);
%create all the points within the unit circle
theta = 0:0.01:2*pi;
p = [cos(theta'),sin(theta')];
%Take only half the points in the heap and keep the points that are less
%than 1 to create a simplex
O = points(:,2) - 2*points(:,1) > 0;
points(O,:) = [];
O = points(:,2) + 2*points(:,1) > 2;
points(O,:) = [];
%draw the points
hull = scatter(points(:,1),points(:,2),'yellow');
hold on;

%Having the graph instantiated, we will dot p and all the points in the
%simplex. Function takes 2 matrixes.
maxU = u(p,points);

%Next we want to determine the approximate half spaces of the simplex. This
%function will take in 3 arguements: p, points, and maxU-h.
arg3 = maxU-h;
[result,  index] = Nh(p,points,arg3)

%Then we will sort the indexes in descending order
[g,I] = sort(index, 'descend')

N = zeros(length(points),1);
ph = zeros(length(points),1);
for k = 1:length(points)
    pcount = zeros(length(p),1);
    a = Inf;
    for i = 1:length(p)
        pxDot = p(i,1)*points(k,1)+p(i,2)*points(k,2);
        for j = 1:length(points)
            pyDot = p(i,1)*points(j,1)+p(i,2)*points(j,2);
            if pyDot >= pxDot - h
                pcount(i) = pcount(i) + 1;
            end
        end
    end
    [a, i] = min(pcount);
    N(k) = a;
    ph(k) = i;
end

[Nhs, J] = sort(N)
J(1:20)

dtheta = 0.5;
thetaList = zeros(0);
x = -0.1:0.01:1.1;
j = 1;
while length(thetaList) <= 2
    y = (maxU(I(j)) - p(I(j),1)*x) / p(I(j),2);
    ans = theta(I(j));
    a = 1;
    for k = 1:length(thetaList)
        if abs(ans-thetaList(k)) <= dtheta
            a = 0;
        end
    end
    if a == 1
        pause;
        plot(x,y,'blue')
        thetaList(end+1) = ans;
    end
    j = j + 1;
end
pointsList = zeros(0);

i = 1;
interior = zeros(3,1);
while length(pointsList) <= 2
    ans1 = points(I(i));
    a = 1;
    for j = 1:length(pointsList)
        if abs(ans1-pointsList(j)) <= dtheta
            a = 0;
        end
    end
    if a == 1
        scatter(points(J(i),1),points(J(i),2),'red')
        pointsList(end+1) = ans1;
        interior(i,1) = points(J(i),1);
        interior(i,2) = points(J(i),2);
    end
    for z = 1:length(interior) %Trying to isolate 3 unique points.
        if points(z,1) == 0
            points(z,1) = [];
        end
        if points(z,2) == 0
            points(z,2) = [];
        end
    end
    i = i+1;
end
