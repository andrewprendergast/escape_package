%% Function detecting tail angle from RDVision tracking, returns several useful parameters

function [tailAngle, fishPosition, headDirection] = tailangle(trackingData)

% head direction detected by ZebraZoom
headDirection = [trackingData(:,4)];
tailAngle=[trackingData(:,5)]/pi*180;
fishPosition = [trackingData(:,2),  trackingData(:,3)];
