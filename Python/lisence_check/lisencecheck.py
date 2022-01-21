#*-* encoding: utf-8 *-*
import os, re
import chardet
import subprocess
import unicodecsv as csv
import numpy as np
import pandas as pd 
import re
from pandas.plotting import  table
import matplotlib.pyplot as plt
import dataframe_image as dfi

obj = subprocess.Popen(["cmd"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True, encoding="utf-8")
obj.stdin.write("abaqus licensing dslsstat -usage")
obj.stdin.write("\n")
obj.stdin.close()

cmd_out = obj.stdout.read()
obj.stdout.close()
cmd_error = obj.stderr.read()
obj.stderr.close()

cmd_out2 = cmd_out.splitlines()
#cmd_out2 = cmd_out2.split('|')

out3 = np.array(cmd_out2).T

df=pd.DataFrame(out3)
df=df[0].str.split('|', expand=True)
df1=df[0].str.split(',', expand=True)
df1[['a','b','c','day','time','f','linum','h']]=df1[1].str.split('\s', expand=True)
#df=pd.concat([df1,df2], axis=1)
df=df1.drop(df1.tail(2).index) #从尾部去掉 n 行

for idx in reversed(df.index):
    if df.loc[idx,'linum'] == None :
        break
df5=df.drop(df.head(idx).index)
df5=df5.drop([1,'a','b','c'], axis=1)
df5['linum'] = df5['linum'].astype(float)
df6=df5.groupby([0,'time'], sort=False)['linum'].sum().reset_index()
lisum=df6['linum'].sum()
remin='remaing:'+str(570-lisum)
df6.loc[0]=['All lisence is 570',remin,lisum]
print(df6)
#########################
#グラフ化
#########################
# fig = plt.figure(figsize=(3, 4), dpi=1400)
# ax = fig.add_subplot(111, frame_on=False) 
# ax.xaxis.set_visible(False)  # hide the x axis
# ax.yaxis.set_visible(False)  # hide the y axis
# table(ax, df6, loc='center')  # 将df换成需要保存的dataframe即可
#plt.savefig('license.png')
df_styled = df6.style.background_gradient()
dfi.export(df_styled,"V:\wiki\public\images\lisence.png")
#df6.to_csv('result.csv')
