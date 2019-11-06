from keras.models import Sequential, load_model
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
import sklearn.metrics
from keras.layers import Dense
import numpy
import tensorflow as tf
from sklearn.preprocessing import RobustScaler,StandardScaler

seed = 0
numpy.random.seed(seed)
tf.compat.v1.random.set_random_seed(seed)

dataset=numpy.loadtxt('C:/Users/YOUNG/PycharmProjects/HyperTension/INTEGRATED_I109_2_6YEAR_2years.csv',delimiter=",")

X=dataset[:,0:36]
Y_obj=dataset[:,35]

e = LabelEncoder()
e.fit(Y_obj)
Y=e.transform(Y_obj)

X_train,X_test,Y_train,Y_test=train_test_split(X,Y,test_size=0.3,random_state=seed)
X_train_valid,X_valid,Y_train_valid,Y_valid=train_test_split(X_train,Y_train,test_size=0.2,random_state=seed)

sc = RobustScaler()
X_train_valid = sc.fit_transform(X_train_valid)
X_valid = sc.transform(X_valid)

model=Sequential()
model.add(Dense(30,input_dim=36,activation='relu'))
model.add(Dense(15,activation='relu'))
model.add(Dense(8,activation='relu'))
model.add(Dense(1,activation='sigmoid'))
model.compile(loss='binary_crossentropy',optimizer='adam',metrics=['accuracy'])
model.fit(X_train_valid,Y_train_valid,epochs=20,batch_size=200)

print("\n Accuracy: %.4f" % (model.evaluate(X_valid,Y_valid)[1]))

pred_valid = model.predict(X_valid,verbose=1)
pred2_valid = pred_valid.reshape(1728,)
for i in range(len(pred2_valid)):
    if pred2_valid[i]<0.5:
        pred2_valid[i]=0
    else:
        pred2_valid[i]=1

print ( "Accuracy_valid  {} ".format(sklearn.metrics.accuracy_score(Y_valid,pred_valid)))
print ( "Precision_valid  {} ".format(sklearn.metrics.precision_score(Y_valid,pred_valid)))
print ( "Recall_valid  {} ".format(sklearn.metrics.recall_score(Y_valid,pred_valid)))
print ( "F1_valid  {} ".format(sklearn.metrics.f1_score(Y_valid,pred_valid)))


#validation set을 통한 모델 생성후 test set을 통해 검증

print("\n Accuracy: %.4f" % (model.evaluate(X_test,Y_test)[1]))
pred = model.predict(X_test,verbose=1)
pred2 = pred.reshape(3702,)
for i in range(len(pred2)):
    if pred2[i]<0.5:
        pred2[i]=0
    else:
        pred2[i]=1


print ( "Accuracy  {} ".format(sklearn.metrics.accuracy_score(Y_test,pred)))
print ( "Precision  {} ".format(sklearn.metrics.precision_score(Y_test,pred)))
print ( "Recall  {} ".format(sklearn.metrics.recall_score(Y_test,pred)))
print ( "F1  {} ".format(sklearn.metrics.f1_score(Y_test,pred)))
