%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main file for Experiment 1 (single cell) for the TIE tutorial.
% Version 2.0 -
% Related Reference:
% "Transport-of-intensity equation£ºA tutoral"
% Chao Zuo, Jiaji Li, Jiasong Sun,Yao Fan, Jialin Zhang, Linpeng Lu, Runnan Zhang,
% Bowen Wang, Lei Huang, Qian Chen
% last modified on 02/27/2021
% by Chao Zuo (zuochao@njust.edu.cn,surpasszuo@163.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear everything existing.
clc
close all
clearvars
addpath('Functions/');

%% Setting up system parameters
I0 = double(imread('Data/On Axis - z=0.png'));
Iz = double(imread('Data/On Axis - z=10.png'));
Iref = double(imread('Data/Reference.png'));
Mask = logical(rgb2gray(imread('Data/Mask.png')));
I0 = I0./Iref;
Iz = Iz./Iref;
I0 = I0(300:800,575:1240);
Iz = Iz(300:800,575:1240);
Mask = Mask(300:800,575:1240);

Pixelsize = 2.4e-6/20*200/150;  % Pixelszie
lambda = 532e-9;           % Wavelength (m)
k = 2*pi/lambda;           % Wave number
dz = 10e-6;       	   % Defocus distance (m)

% Axial intensity derivative
dIdz = (Iz-I0)/(dz);

%% Solve TIE with iteration parameters.
RegPara = 1e-9;
IntThr = 0.01;
JudgeFlag_DCT = 1;
JudgeFlag_US = 1;
MaxIterNum = 50;
Method = 'Angular Spectrum';  %'TIE','Angular Spectrum','Fresnel'

%% Solve TIE with FFT-TIE.
Phi_FFT = TIE_FFT_solution(dIdz,I0,Pixelsize,k,RegPara,IntThr);
Phi_FFT = -Phi_FFT;


figure;
imagesc(Phi_FFT);
xticks(''); yticks('');
colorbar;
