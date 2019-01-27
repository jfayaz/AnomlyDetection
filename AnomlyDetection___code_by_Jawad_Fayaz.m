clear ; close all; clc; addpath('functions')
%% ====================== ANOMALY DETECTION ============================ %%
%  written by : JAWAD FAYAZ (email: jfayaz@uci.edu)
%  visit: (https://jfayaz.github.io)

%  ------------- Instructions -------------- %
%  INPUT:
%  Input Variables must be in the form of .mat file and must be in same directory
%  Input Variables should include:
%  "X"      -->  Matrix (m,n) with each column as the Input data
%  "Xval"   -->  Matrix (x,n) with each column as the Cross-Validation Set of the "X" Input data
%  "Yval"   -->  Matrix (x,1) with each column as the Cross-Validation Set of the Input data
%
%  OUTPUT:
%  Output will be provided in variable "Outliers"
%  "Outliers" --> Vector (o,1) contains the row numbers of X which are classified as outliers
%  Additional Statistics such as epsilon and F1 score on Cross Validation sets will be displayed too


%%%%% ============================================================= %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ========================= USER INPUTS =============================== %%

%%% Provide your .mat file name here 
%%% For example: 'Exdata1.mat' contains 2-D data and 'Exdata2.mat' contains MultiDimensional data
Matlab_Data_Filename = 'Exdata1.mat';



%%%%%%================= END OF USER INPUT ========================%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(Matlab_Data_Filename);

if size(X,2) == 2
    %% ================== 2-Dimensional Outliers =================== %%
    
    %  Visualizing the example dataset
    plot(X(:, 1), X(:, 2), 'bx');
    xlabel('X(:,1)');
    ylabel('X(:,2)');

    %% ---------- Estimating the dataset statistics ----------
    %  Assuming a Gaussian distribution for the dataset.
    %  First the parameters of the assumed Gaussian distribution are estimated, 
    %  then the probabilities for each of the points are computed and then 
    %  visualizing both the overall distribution and where each of the points 
    %  falls in terms of that distribution.
    fprintf('Visualizing Gaussian fit.\n\n');

    %  Estimating mu and sigma2
    [mu, sigma2] = estimateGaussian(X);

    %  Returns the density of the multivariate normal at each data point (row) of X
    p = multivariateGaussian(X, mu, sigma2);

    %  Visualizing the fit
    visualizeFit(X,  mu, sigma2);
    xlabel('X(:,1)');
    ylabel('X(:,2)');


    %% ---------- Finding Outliers ----------
    %  Finding a good epsilon threshold using a cross-validation set and
    %  probabilities given the estimated Gaussian distribution 
    pval = multivariateGaussian(Xval, mu, sigma2);
    [epsilon, F1] = selectThreshold(yval, pval);
    fprintf('Best epsilon found using cross-validation: %e\n', epsilon);
    fprintf('Best F1 on Cross Validation Set:  %f\n', F1);

    %  Finding the outliers in the training set and plot the
    Outliers = find(p < epsilon);

    %  Drawing a red circle around those outliers
    hold on
    plot(X(Outliers, 1), X(Outliers, 2), 'ro', 'LineWidth', 2, 'MarkerSize', 10);
    hold off
    
    

elseif size(X,2) > 2
    %% ================== Multidimensional Outliers =================== %%
    
    %  Applying the same steps to the larger dataset
    [mu, sigma2] = estimateGaussian(X);

    %  Training set 
    p = multivariateGaussian(X, mu, sigma2);

    %  Cross-validation set
    pval = multivariateGaussian(Xval, mu, sigma2);

    %  Find the best threshold
    [epsilon, F1] = selectThreshold(yval, pval);
    
    %  Finding the outliers in the training set and plot the
    Outliers = find(p < epsilon);

    fprintf('Best epsilon found using cross-validation: %e\n', epsilon);
    fprintf('Best F1 on Cross Validation Set:  %f\n', F1);
    fprintf('# Outliers found: %d\n\n', sum(p < epsilon));
    
    
    
end
