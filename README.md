# Credit-Card-Approval-Prediction-
INTRODUCTION
Credit cards have become one of the most popular modes of payment in the world today. 
The objective of this report is to develop and critically evaluate the machine learning models to predict creditworthiness of credit card applicants, 
and compare models based on certain performance metrics such as their accuracy, sensitivity and specificity and to devise a business strategy for profitability.

METHODOLOGY
The approach to the task was an inductive approach, with the aim of building predictive models that identify customers who should be approved for credit cards.
The six steps of Cross-Industry Standard Process for Data Mining (CRISP-DM) iterative process were employed in developing the models for this credit card approval predictive analysis task. The steps are broken down in the methodology below.  

Modelling 

Machine learning was used to create predictive models firstly by splitting the data into training and test data. To achieve a detailed comparative analysis three categories of test and training data in the ratios of 70:30, 80:20 and 90:10 were created. The choice of models to be used were based on two key factors – the primary objective of the task which is to predict customers that should be approved for credit card applications combined with the available literature reviews on machine learning techniques used in finance to predict credit risk. Based on this, C5, Random Forest, Naïve Bayes and Neural Networks were deemed to be the most suitable models to achieve the desired objectives. More details on this as well as the rationale for each model selection and outputs are discussed in the modelling section.


Prediction Models - Classification 
In this task, we have used classification methods for prediction, which is referred to as supervised learning classification, as the predicted class or target variable is known.
To address the business problem of predicting whether a credit card application will be approved, a decision must be made on whether an applicant is creditworthy or not. The implications of errors in the model are that a creditworthy customer could be declined and a customer who is prone to defaulting could be approved for a credit card. While both scenarios have consequences on the business, the risk of approving a customer who is not creditworthy has more impact on the bottom line as this could result in loss of funds.
Four prediction models were developed and evaluated based on their accuracy, specificity, and sensitivity in a quest to find a solution to the above business problem.
The initial step toward creating models is the feature selection, it is the most critical step before creating the prediction models. It is one of the key components of feature engineering and identifies the most important features to employ as predictors in machine learning algorithms. Due to the problem of multicollinearity, the features such as Flag own car, Name income type, Count Family member have been dropped. The feature flag mobile was also dropped from the dataset as it contains only one value, leaving the dataset unbalanced and biased. The overall objective of this stage is to utilise the most relevant features to create the most efficient model. 
Another crucial step adopted in data modelling is to normalize the range of independent variables or features which makes it easy for a model to learn and understand the problem. The dataset was then divided into test and training sets. We have utilised three splits of (training to test) dataset of 70:30, 80:20, and 90:10 to achieve the best outcomes. We have not used the ‘FOR’ loop for data splits as the Neural network takes a long time to run due to its complexity.   
In the models that have been created, ‘0’ is considered as a positive class. So, in the confusion matrix, '0' is interpreted as Positive and '1' as Negative.

 The following models have been created and evaluated

C5 - Decision Tree: 
This is the first model created for the dataset as the algorithm is majorly used to estimate the likelihood whether a customer would default on a loan by employing predictive model generation with the customer’s historical data. It helps in preventing losses by evaluating a customer's creditworthiness.

Another advantage of using decision trees is that the amount of data cleansing that must be done is reduced. So the performance of the algorithm is least affected by the presence of missing values or outliers. However, in this case, the missing values have already been treated. 

The accuracy for this algorithm is 69.60%, highest for 70:30 (training: test) ratio. However, accuracy is not the only indicator for evaluating the model, there are other parameters such as specificity and sensitivity, which determine the best model. The confusion matrix for the best model in C5 depicts, 3195 customers are predicted to be good customers, however, they are bad customers and would default on payment. Also, we are missing out on 130 good customers which the model predicted as bad.


Figure 9: C5: Confusion Matrix (70:30)



Figure 10: C5: Confusion Matrix (80:20)


Figure 11: C5: Confusion Matrix (90:10)

Table 3: Performance metric for C5



Training: Test data
Accuracy
Sensitivity
Specificity
70:30
69.6%
98.30%
2.05%
80:20
69%
97.51%
3.92%
90:10
69.56%
95.84%
4.11%


Random Forest:
When using the Random Forest method, determining the relative relevance of each feature to the prediction is a simple and straightforward process. The characteristics to be eliminated from the model can be determined by looking at the relevance of the features, to confirm the ones that have little or no contribution to the prediction process. This is significant as one of the fundamental rules in machine learning is that the more features a model possesses, the greater the likelihood that it will suffer from overfitting, and vice versa. 

The highest accuracy for this model is 71.34% for 90:10 (training: test) split with a sensitivity of 100%. The confusion matrix for the best model in Random forest depicts, 1045 customers are predicted to be good customers, however, they are bad customers and would default on payment. However, in this model, we are not missing out on any good customers.


70:30

Figure 12:

	
	
	Figure 13: Random Forest: Confusion Matrix (70:30)

	80:20

Figure 14: Randon forest OOB graph 

		
Figure 15: Random Forest: Confusion Matrix (80:20)

90:10

Figure 16: Random forest OOB graph

Figure 17: Random Forest: Confusion Matrix (90:10)

Table 4: Performance metric for Random Forest
Training: Test data
Accuracy
Sensitivity
Specificity
70:30
70.16%
99.96%
0.03%
80:20
69.4%
99.74%
0.13%
90:10
71.34%
100%
0%


Naïve Bayes
The Naive Bayes algorithm is one of the most common machine learning methods that makes use of Bayesian methods. It derives its name from its characteristic of making some "naive" assumptions about the data. Specifically, it treats all the features in the dataset independently and equally based on importance. Although not all features are crucial when applying in the real world, Naïve Bayes performs moderately well in most of the cases where the assumptions are breached. Naïve Bayes is however usually a first choice for consideration for classification learning tasks due to its adaptability and accuracy across various scenarios.

The highest accuracy for this model is 71.39% for 90:10 (training: test) ratio with a very high sensitivity. The confusion matrix for the best model in Naive Bayes depicts that 1039 customers are predicted to be good customers, however, they are bad customers and would default on payment. Here, we are missing out only on 4 good customers which the model predicted as bad.

70:30  

	
			Figure 18:  Naive Bayes: Confusion Matrix (70:30)
        80:20
	
	
Figure 19: Naive Bayes: Confusion Matrix (80:20)
90:10


	
Figure 20: Naive Bayes: Confusion Matrix (90:10)

Table 5: Performance metric for Naïve Bayes
Training: Test data
Accuracy
Sensitivity
Specificity
70:30
70.23%
99.97%
0.24%
80:20
69.57%
100%
0%
90:10
71.39%
99.84%
0.57%


Neural Network
Artificial Neural Networks (ANN) mimic the way the brain creates a processor by using a system of interlinked cells providing solutions to machine learning problems. Artificial Neural Network models are made up of a layer that provides input, a layer that is hidden, a results layer and a function that activates the model. ANNs are usually recommended for learning tasks such as classification, estimation of functions and pattern recognitions. Despite their slowness and processing requirements, they are a popular option for credit risk and loan default prediction applications. The algorithm's main advantages are its ability to represent more complex patterns than other algorithms and its flexibility to numeric and classification prediction tasks.

The accuracy for this model is 30.6% on 80:20 (training : test) ratio, implying that the model underperforms on the chosen dataset. The confusion matrix for the best model in the Neural network depicts 7 customers are predicted to be good customers, however, they are bad customers and would default on payment. Also, we are missing out on 5053 good customers which the model predicted as bad.


