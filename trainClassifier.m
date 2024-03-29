function [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% Returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: A table containing the same predictor and response
%       columns as those imported into the app.
%
%  Output:
%      trainedClassifier: A struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: A function to make predictions on new
%       data.
%
%      validationAccuracy: A double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 01-Oct-2021 10:43:29


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'signal__required_value__fan_exahust_air', 'logic__real_value__filter_exahust_air', 'logic__real_value__fan_fresh_air', 'logic__real_value__air_handling_unit', 'signal__required_value__heater_valve', 'water_temperature__required_value__heater', 'air_temperature__required_value__exahust_air_inlet', 'signal__min__fan_fresh_air', 'logic__required_value__valve_exahust_air_outlet', 'air_temperature__max__supply_air_outlet', 'logic__real_value__filter_outdoor_air', 'logic__required_value__valve_outdoor_air', 'water_temperature__real_value__heater_behind', 'air_temperature__real_value__exahust_air_inlet', 'air_temperature__min__supply_air_outlet', 'air_temperature__real_value__supply_air_outlet', 'water_temperature__real_value__chiller_behind', 'signal__required_value__heat_recovery_bypass', 'water_temperature__real_value__heater_before', 'logic__real_value__fan_exahust_air', 'logic__required_value__heater', 'logic__required_value__chiller_pump', 'logic__required_value__heater_pump', 'logic__required_value__chiller', 'signal__required_value__chiller_valve', 'signal__required_value__fan_fresh_air', 'signal__max__fan_fresh_air', 'equipment'};
predictors = inputTable(:, predictorNames);
response = inputTable.fault;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationNeuralNetwork = fitcnet(...
    predictors, ...
    response, ...
    'LayerSizes', 100, ...
    'Activations', 'relu', ...
    'Lambda', 0, ...
    'IterationLimit', 1000, ...
    'Standardize', true, ...
    'ClassNames', categorical({'Both fan differential pressure sensor tubes are disconnected'; 'Cooling pump is ON during heating regime'; 'Cooling valve is closed during cooling regime'; 'Dampers are closed during cooling regime'; 'Dampers are closed during heating regime'; 'Dampres are closed during ventilate regime'; 'Fans are OFF during heating regime'; 'Heat exchanger is closed'; 'Heating pump is OFF during heating regime'; 'Heating pump is ON and valve is opened during ventilate regime'; 'Heating pump is ON during ventilate regime'; 'Heating valve is ON during ventilate regime'; 'Heating valve is closed during heating regime'; 'Heating valve is open to the maximum level during cooling regime'; 'Heating valve is open to the maximum level during heating regime'; 'Heating valve is stuck in intermediate position during cooling regime'; 'Heating valve is stuck in intermediate position during heating regime'; 'One of fan differential pressure sensor tubes is disconnected'; 'Quick regimes cycling'; 'Zone inlet temperature sensor indicates -20 °C'; 'Zone inlet temperature sensor indicates 150 °C'; 'Zone outlet temperature sensor indicates -20 ° C'; 'Zone outlet temperature sensor indicates 150 °C'; 'no fault'}));

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
neuralNetworkPredictFcn = @(x) predict(classificationNeuralNetwork, x);
trainedClassifier.predictFcn = @(x) neuralNetworkPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'air_temperature__max__supply_air_outlet', 'air_temperature__min__supply_air_outlet', 'air_temperature__real_value__exahust_air_inlet', 'air_temperature__real_value__supply_air_outlet', 'air_temperature__required_value__exahust_air_inlet', 'equipment', 'logic__real_value__air_handling_unit', 'logic__real_value__fan_exahust_air', 'logic__real_value__fan_fresh_air', 'logic__real_value__filter_exahust_air', 'logic__real_value__filter_outdoor_air', 'logic__required_value__chiller', 'logic__required_value__chiller_pump', 'logic__required_value__heater', 'logic__required_value__heater_pump', 'logic__required_value__valve_exahust_air_outlet', 'logic__required_value__valve_outdoor_air', 'signal__max__fan_fresh_air', 'signal__min__fan_fresh_air', 'signal__required_value__chiller_valve', 'signal__required_value__fan_exahust_air', 'signal__required_value__fan_fresh_air', 'signal__required_value__heat_recovery_bypass', 'signal__required_value__heater_valve', 'water_temperature__real_value__chiller_behind', 'water_temperature__real_value__heater_before', 'water_temperature__real_value__heater_behind', 'water_temperature__required_value__heater'};
trainedClassifier.ClassificationNeuralNetwork = classificationNeuralNetwork;
trainedClassifier.About = 'This struct is a trained model exported from Classification Learner R2021a.';
trainedClassifier.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'signal__required_value__fan_exahust_air', 'logic__real_value__filter_exahust_air', 'logic__real_value__fan_fresh_air', 'logic__real_value__air_handling_unit', 'signal__required_value__heater_valve', 'water_temperature__required_value__heater', 'air_temperature__required_value__exahust_air_inlet', 'signal__min__fan_fresh_air', 'logic__required_value__valve_exahust_air_outlet', 'air_temperature__max__supply_air_outlet', 'logic__real_value__filter_outdoor_air', 'logic__required_value__valve_outdoor_air', 'water_temperature__real_value__heater_behind', 'air_temperature__real_value__exahust_air_inlet', 'air_temperature__min__supply_air_outlet', 'air_temperature__real_value__supply_air_outlet', 'water_temperature__real_value__chiller_behind', 'signal__required_value__heat_recovery_bypass', 'water_temperature__real_value__heater_before', 'logic__real_value__fan_exahust_air', 'logic__required_value__heater', 'logic__required_value__chiller_pump', 'logic__required_value__heater_pump', 'logic__required_value__chiller', 'signal__required_value__chiller_valve', 'signal__required_value__fan_fresh_air', 'signal__max__fan_fresh_air', 'equipment'};
predictors = inputTable(:, predictorNames);
response = inputTable.fault;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true];

% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.2);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
trainingIsCategoricalPredictor = isCategoricalPredictor;

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationNeuralNetwork = fitcnet(...
    trainingPredictors, ...
    trainingResponse, ...
    'LayerSizes', 100, ...
    'Activations', 'relu', ...
    'Lambda', 0, ...
    'IterationLimit', 1000, ...
    'Standardize', true, ...
    'ClassNames', categorical({'Both fan differential pressure sensor tubes are disconnected'; 'Cooling pump is ON during heating regime'; 'Cooling valve is closed during cooling regime'; 'Dampers are closed during cooling regime'; 'Dampers are closed during heating regime'; 'Dampres are closed during ventilate regime'; 'Fans are OFF during heating regime'; 'Heat exchanger is closed'; 'Heating pump is OFF during heating regime'; 'Heating pump is ON and valve is opened during ventilate regime'; 'Heating pump is ON during ventilate regime'; 'Heating valve is ON during ventilate regime'; 'Heating valve is closed during heating regime'; 'Heating valve is open to the maximum level during cooling regime'; 'Heating valve is open to the maximum level during heating regime'; 'Heating valve is stuck in intermediate position during cooling regime'; 'Heating valve is stuck in intermediate position during heating regime'; 'One of fan differential pressure sensor tubes is disconnected'; 'Quick regimes cycling'; 'Zone inlet temperature sensor indicates -20 °C'; 'Zone inlet temperature sensor indicates 150 °C'; 'Zone outlet temperature sensor indicates -20 ° C'; 'Zone outlet temperature sensor indicates 150 °C'; 'no fault'}));

% Create the result struct with predict function
neuralNetworkPredictFcn = @(x) predict(classificationNeuralNetwork, x);
validationPredictFcn = @(x) neuralNetworkPredictFcn(x);

% Add additional fields to the result struct


% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = validationPredictFcn(validationPredictors);

% Compute validation accuracy
correctPredictions = (validationPredictions == validationResponse);
isMissing = ismissing(validationResponse);
correctPredictions = correctPredictions(~isMissing);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);
