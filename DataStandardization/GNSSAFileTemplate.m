function [HeadItem HeadContent IdxText formats] = GNSSAFileTemplate()    
HeadItem = {'DateUTC'
            'Ref_Frame'
            'GNSS_Mode'
            'Ate_Ht'
            'Site_name'
            'NEU_Ref'
            'Site_No'
            'Sessions'
            'Lines'
            'Sampling'
            'Arm_Len'
            'HDW_Delay'
            'Stn_xH'
            'Stn_Dx'};
HeadContent = {''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''
            ''};
formats = {'%d\t','%d\t','%d\t',...
'%6f\t','%d\t','%d\t','%d\t',...
'%d\t','%6f\t','%6f\t','%6f\t',...
'%6f\t','%6f\t','%6f\t','%6f\t',...
'%6f\t','%6f\t','%6f\t','%6f\t',...
'%6f\t','%6f\t','%6f\t','%6f\t','%6f\t','%6f\t'};
IdxText = '$ SET_LN_MT :  TT ResiTT TakeOff gamma flag ST ant_n0 ant_e0 ant_u0 head0 pitch0 roll0 RT ant_e1 ant_n1 ant_u1 head1 pitch1 roll1';