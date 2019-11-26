function fid = CreateWRL(fid,texture,points)
%CREATEVRML This function writes and formats a face and its configuration
%to a wrl file
%   Params:
%   fid = the file we want to write the shape to
%   texture = the .bmp file name of that face
%   points = the points we want the texture to be defined by in order of
%               0,1,2,3
%   Outputs:
%   fid = the file we want to write the shape to

fprintf(fid,'Shape {\n  appearance Appearance {\n   texture ImageTexture {\n    ');
fprintf(fid,'url "%s" \n}\n}\n',texture);
fprintf(fid,'geometry IndexedFaceSet {\n    coord Coordinate {\n    point [\n   ');
fprintf(fid,'%.6f %.6f %.6f,\n',points(1,1),points(2,1),points(3,1));
fprintf(fid,'%.6f %.6f %.6f,\n',points(1,2),points(2,2),points(3,2));
fprintf(fid,'%.6f %.6f %.6f,\n',points(1,3),points(2,3),points(3,3));
fprintf(fid,'%.6f %.6f %.6f,\n]\n}\n',points(1,4),points(2,4),points(3,4));
fprintf(fid,'coordIndex [\n     0, 1, 2, 3, -1,\n]\n');
fprintf(fid,'texCoord TextureCoordinate {\n     point [\n');
fprintf(fid,'-0.000000 0.000000,\n1.000000 0.000000,\n1.000000 1.000000,\n-0.000000 1.000000,\n]\n}\n');
fprintf(fid,'texCoordIndex [\n  0, 1, 2, 3, -1,\n]\nsolid FALSE\n}\n}\n');

end
