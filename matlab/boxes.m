%function ell = boxes()
clear
plot3dgrid = true;
plot2dgrid = false;
userays = 1;  %indices of rays to use. If you want to use rays 1 and 2, userays = 1:2.  if you want rays 1,3,4 userays = [1 3 4]

dx = 10;
dy = 10;
dz = 10;
xCenters(:,1) = -10:dx:10; 
yCenters(:,1) = -10:dy:10; 
zCenters(:,1) = 100:dz:150;

xc(:,1) = [xCenters - 0.5*dx; xCenters(end) + 0.5*dx];
yc(:,1) = [yCenters - 0.5*dy; yCenters(end) + 0.5*dy];
zc(:,1) = [zCenters - 0.5*dz; zCenters(end) + 0.5*dz];

[xcm,ycm,zcm] = meshgrid(xc,yc,zc);

figure(1),clf(1)
if plot3dgrid
scatter3(xcm(:),ycm(:),zcm(:),'.'); %sets up proper axes limits
axis('tight')
end
    
xlabel('x'), ylabel('y'),zlabel('z')
title('3-D grid corners and line segments')
hold('on')

figure(2),clf(2)
cp = get(2,'pos');
set(2,'pos',[cp(1),cp(2),1250,500]);

axy = axes('parent',2,'pos',[0.035,0.075,0.295,0.8]);
if plot2dgrid
    scatter(xcm(:),ycm(:),'.k')
    axis('tight')
end
xlabel('x'), ylabel('y')
hold('on')

axz = axes('parent',2,'pos',[0.365,0.075,0.295,0.8]);
if plot2dgrid
    scatter(xcm(:),zcm(:),'.k')
    axis('tight')
end
xlabel('x'), ylabel('z')
hold('on')

ayz = axes('parent',2,'pos',[0.695,0.075,0.295,0.8]);
if plot2dgrid
    scatter(ycm(:),zcm(:),'.k')
    axis('tight')
end
xlabel('y'), ylabel('z')
hold('on')

title('2-D grid corners and line segments')
hold('on')
%trying to define two rays, first ray with endpoints (0,0,0), (0,20,1000)
% second ray with endpoints (0,0,0),(15,20,1000)

r0x0 = 0; 
r0y0 = 0;
r0z0 = 0;

r0x1 = 15;
r0y1 = -23;
r0z1 = 500;

r1x0 = 0;
r1y0 = 0;
r1z0 = 0;

r1x1 = -10;
r1y1 = 84;
r1z1 = 1000;



rayxy= [r0x0 r0x1 r0y0 r0y1;   
        r1x0 r1x1 r1y0 r1y1]; 

rayxz = [r0x0 r0x1 r0z0 r0z1; 
         r1x0 r1x1 r1z0 r1z1];

rayyz = [r0y0 r0y1 r0z0 r0z1;
         r1y0 r1y1 r1z0 r1z1];
    
    %nr = size(rayxy,1); %all "rays" should have the same number of rows
    nr = length(userays);
    nx = length(xCenters); %NOT xc
    ny = length(yCenters);
    nz = length(zCenters);
    
ell = zeros(nr,nx,ny,nz);

colors = ['b','r','g','y','m','k']; % to distinguish lines belonging to up to 6 rays 

for ri = userays
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
                if ~isempty(xo) && ~isempty(yo) && ~isempty(zo)
                    % OK, save this line length
                    ell(ri,xi,yi,zi) = sqrt(diff(xo) + diff(yo) + diff(zo));
                    % and plot in the 3-D grid
                    figure(1)
                    plot3(xo,yo,zo,'color',colors(ri))
                    % and plot in each of the 2-D panels
                    
                    plot(xo,yo,'color',colors(ri),'parent',axy) 
                    plot(xo,zo,'color',colors(ri),'parent',axz)
                    plot(yo,zo,'color',colors(ri),'parent',ayz)
                    %display([xo,yo,zo])
                    pause
                end
            end
        end
    end
end

if ~nargout, clear, end

%end
