function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Part 1: Feedforward neural network calcuation of cost function

a_1 = [ones(size(X,1),1) X];         % input Layer + bias parameter
z_2 = a_1 * Theta1';     % calculation of hidden layer
a_2 = sigmoid(z_2);
a_2 = [ones(size(a_2,1),1) a_2];
z_3 = a_2 * Theta2'; % hidden Layer + bias parameter
a_3 = sigmoid(z_3);            % calcuation of output layer
h = a_3;

%a_1 = X;         % input Layer + bias parameter
%z_2 = [ones(size(a_1,1),1) a_1] * Theta1';     % calculation of hidden layer
%a_2 = sigmoid(z_2);
%z_3 = [ones(size(a_2,1),1) a_2] * Theta2'; % hidden Layer + bias parameter
%a_3 = sigmoid(z_3);            % calcuation of output layer
%h = a_3;

% Part 2.1 output vector preparation 
Y = [y==1];
for i = 2:1:num_labels
  Y = [Y y==i];
endfor

% Calcuation of cost function
J = -Y .* log(h) - (ones(size(Y))-Y) .* log(ones(size(h))-h);
J = sum(sum(J));
J = J/m;

% Part 2: Back propogation algorithm

del3 = a_3 - Y; 
del2 = (del3 * Theta2) .* sigmoidGradient([ones(size(z_2,1),1) z_2]);
Delta_1 = del2(:, 2:end)' * a_1;
%Delta_1 = Delta_1(2:end);
Delta_2 = del3' * a_2;
%Delta_2 = Delta_2(2:end);
Theta1_grad = Delta_1./m;
Theta2_grad = Delta_2./m;
% Part 3: Implemenation of regularized cost function and gradient

Theta1(:,1) = zeros(size(Theta1,1),1);
Theta2(:,1) = zeros(size(Theta2,1),1);
J = J + lambda/2/m * (sum(sum(Theta1.*Theta1)) + sum(sum(Theta2.*Theta2)));
% ---------------- ---------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
