import streamlit as st
import pandas as pd

ani_list = ['짱구는못말려', '몬스터','릭앤모티']
img_list = ['https://i.imgur.com/t2ewhfH.png', 
            'https://i.imgur.com/ECROFMC.png', 
            'https://i.imgur.com/MDKQoDc.jpg']

ani_dict = dict()
for i in range(len(ani_list)):
    ani_dict[ani_list[i]] = img_list[i]


# # 텍스트를 입력받아서 해당 텍스트와 일치하는 이미지를 화면에 출력하는 검색창을 만들어 주세요.
user_input = st.text_input('찾을 이미지')
if user_input in ani_list:
    st.image(ani_dict.get(user_input))
elif user_input != "":
    st.write("이미지를 찾을 수 없습니다.")
else:
    st.write("공백 없이 입력")
