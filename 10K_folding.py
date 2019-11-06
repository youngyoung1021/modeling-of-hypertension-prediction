from keras.models import Sequential, load_model
from sklearn.preprocessing import LabelEncoder
from keras.layers import Dense
import numpy
import tensorflow as tf
from sklearn.model_selection import StratifiedKFold
import sklearn.metrics
seed = 0
numpy.random.seed(seed)
tf.compat.v1.random.set_random_seed(seed)

dataset=numpy.loadtxt('C:/Users/YOUNG/PycharmProjects/HyperTension/INTEGRATED_I109_2_6YEAR_2years.csv',delimiter=",")

X=dataset[:,0:26]
Y_obj=dataset[:,26]

e = LabelEncoder()
e.fit(Y_obj)
Y=e.transform(Y_obj)

n_fold=10
skf=StratifiedKFold(n_splits=n_fold,shuffle=True,random_state=seed)

accuracy=[]

for train,test in skf.split(X,Y):
    model=Sequential()
    model.add(Dense(30,input_dim=26,activation='relu'))
    model.add(Dense(15,activation='relu'))
    model.add(Dense(8,activation='relu'))
    model.add(Dense(1,activation='sigmoid'))
    model.compile(loss='binary_crossentropy',optimizer='adam',metrics=['accuracy'])
    model.fit(X[train],Y[train],epochs=20,batch_size=100)
    k_accuracy="%.4f" % (model.evaluate(X[test],Y[test])[1])
    accuracy.append(k_accuracy)

print("\n %.f fold accuracy:" % n_fold,accuracy)


