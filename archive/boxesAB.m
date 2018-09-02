%function ell = boxes()
dx = 10;
dy = 10;
dz = 10;
xCenters(:,1) = 0:dx:50; 
yCenters(:,1) = 0:dy:50; 
zCenters(:,1) = 300:dz:350;

xc(:,1) = [xCenters - 0.5*dx; xCenters(end) + 0.5*dx];
yc(:,1) = [yCenters - 0.5*dy; yCenters(end) + 0.5*dy];
zc(:,1) = [zCenters - 0.5*dz; zCenters(end) + 0.5*dz];

[xcm,ycm,zcm] = meshgrid(xc,yc,zc);

figure(1),clf(1)
scatter3(xcm(:),ycm(:),zcm(:))
xlabel('x'), ylabel('y'),zlabel('z')
title('3-D grid corners and line segments')
hold('on')

figure(2),clf(2)
scatter(xcm(:),ycm(:))
xlabel('x'), ylabel('y')
title('2-D grid corners and line segments')
hold('on')
%trying to define two rays, first ray with endpoints (0,0,0), (0,20,1000)
% second ray with endpoints (0,0,0),(15,20,1000)

r0x0 = 0; 
r0y0 = 0;
r0z0 = 0;

r0x1 = 75;
r0y1 = 60;
r0z1 = 506;

r1x0 = 0;
r1y0 = 0;
r1z0 = 0;

r1x1 = 29;
r1y1 = 96;
r1z1 = 670;



rayxy= [r0x0 r0x1 r0y0 r0y1;   %r0x0 r0y0 r0x1 r0y1
        r1x0 r1x1 r1y0 r1y1]; %r1x0 r1y0 r1x1 r1y1

rayxz = [r0x0 r0x1 r0z0 r0z1;   %r0x0 r0z0 r0x1 r0z1
         r1x0 r1x1 r1z0 r1z1]; %r1x0 r1z0 r1x1 r1z1

rayyz = [r0y0 r0y1 r0z0 r0z1;
         r1y0 r1y1 r1z0 r1z1];
    
    nr = size(rayxy,1);
    nx = length(xCenters); %NOT xc
    ny = length(yCenters);
    nz = length(zCenters);
    
ell = zeros(nr,nx,ny,nz);

colors = ['b','r','g','y','m','k']; % to distinguish lines belonging to up to 6 rays 

for ri = 1:nr
    for xi = 1:nx
        for yi = 1:ny
            for zi = 1:nz
                %consider x,y
                % left&right in x, top&bottom in y
                leftXY = xc(xi); rightXY = xc(xi+1);
                bottomXY =yc(yi);topXY = yc(yi+1);
                [xoo,yoo] = lineclip(rayxy(ri,:),...
                                   [leftXY,  rightXY, bottomXY, topXY]); %xo output is INVALID from this perspective!
                %consider x,z
            
                % left&right sides are in x, top and bottom sides in z
                leftXZ = xc(xi); rightXZ = xc(xi+1);
                bottomXZ = zc(zi); topXZ = zc(zi+1);
                [xo,zo] = lineclip(rayxz(ri,:),...
                                   [leftXZ,   rightXZ,  bottomXZ, topXZ ]);
                               
                %consider y,z
                leftYZ = yc(yi); rightYZ = yc(yi+1);
                bottomYZ = zc(zi); topYZ = zc(zi+1);
                 [yo,zoo] = lineclip(rayyz(ri,:),...
                                    [leftYZ,   rightYZ,  bottomYZ, topYZ ]);          
                % deciding which value to use
                if diff(xo)>2
                    x = xo;
                else
                    x = xoo;
                end
                
                if diff(yo)>2
                    y = yo;
                else
                    y = yoo;
                end
                if ~isempty(xo) && ~isempty(yo) && ~isempty(xoo)
                  %if ~all(xo==xoo), warning('x distances didnt match'), end
%                  if ~isempty(yo) && ~isempty(yoo) %both "looks" found an intersection
%                     if ~all(yo==yoo), warning('y distances didnt match'), end
                    ell(ri,xi,yi,zi) = sqrt(diff(xo) + diff(yo) + diff(zo));
                    figure(1)
                    plot3(xo,yo,zo,'color',colors(ri))
                    pause(3)
                    figure(2)
                    plot(xo,yo,'color',colors(ri))
                    o = [xo,yo,zo]
                    oo = [xoo,yoo,zoo]
                    
                    
                                leftYZ
                                rightYZ
                                bottomYZ
                                topYZ
                                
                                pause(.5)
                    
                end
            end
        end
    end
end
size(ell)
size(zCenters)

% creates electron density field
ne = repmat(zCenters',2,1,6,6);
ne = chapman(ne);
size(ne)

% finds line integral 
total = 0;
positions = find(ell~=0);
for j = 1:ri
    for i = 1:length(positions)
    [r c a b] = ind2sub(size(ell),positions(i));
    if r == j
        total = total + (ell(r,c,a,b)*ne(r,c,a,b));
        integral(j) = total;
    end
    end
end
integral
ell

if ~nargout, clear, end

%end
