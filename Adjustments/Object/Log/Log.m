classdef Log < handle
    properties
%       path
%       filename
       fd
    end
    methods
       function obj = Log() %path,filename)
%            obj.path     = path;
%            obj.filename = filename;
%            filepath     = fullfile(path,filename);
           obj.fd       = fopen('D:\github\Adjustments\Log.txt','a+');
       end
       function WriteIn(obj,y,format)
           fprintf(obj.fd,format,y);
       end
       function fclose(obj)
           fclose(obj.fd);
       end
    end
end