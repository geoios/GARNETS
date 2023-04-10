function [TransducerPoint,R2] = ArmCalibration_Jap(ArmLength,Attitude,ConversionPoint)
Attitude = Attitude * (pi/180);
R2 = RotationMatrixR2_New(Attitude(1),Attitude(2),Attitude(3));

% R2 = [R2(2,:);R2(1,:);R2(3,:)];      % [N E U]

TransformPar    =  (R2 * ArmLength)';
TransformPar(3) = TransformPar(3) * -1;
TransducerPoint = TransformPar + ConversionPoint;


% R1 = [R2(2,:);R2(1,:);R2(3,:)]
% TransformPar1 = (R1 * ArmLength)'
% 
% 
% R3 = [R2(:,2);R2(:,1);R2(:,3)]
% ArmLength1 = [ArmLength(2);ArmLength(1);ArmLength(3)];
% TransformPar3 = (R2 * ArmLength)';




end