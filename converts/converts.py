# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import numpy as np

class converts:
    def __init__(self,convertPrice,up,upWindow,\
                 upCounts,down,downWindow,downCounts,\
                 coupon,finalPay):
        self.up = up #强赎条款
        self.down = down #下修条款
        self.upWindow = upWindow #强赎条款观察窗口
        self.downWindow = downWindow #下修条款观察窗口
        self.upCounts = upCounts #强赎条款触发日期数
        self.downCounts = downCounts #下修条款触发日期数
        self.convertPrice = convertPrice #约定转股价格
        self.coupon = coupon #票息期限结构
        self.finalPay = finalPay #最后赎回价格  
        
    def simulator(self,S0,randomNumber):
        return 0
    
    def repayment(self,St):
        res = np.zeros_like(St)
        convertPrice = self.convertPrice
        up = self.up
        down = self.down
        for i in range(0,len(St)):
            if St>=up: # 这里得改
                res[i] = 100/convertPrice * self.up
            if St<=self.down: #这里也需要按照规则修改
                convertPrice = down
                up = up * convertPrice/self.convertPrice
                down = down * convertPrice/self.convertPrice
        return res
                
    def discount(self,r):
        return 0
    
    def greeks(self):
        return 0
                
            
        
    