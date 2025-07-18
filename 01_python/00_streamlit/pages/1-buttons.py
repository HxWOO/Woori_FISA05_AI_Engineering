import streamlit as st
import pandas as pd


# 1. 버튼을 누르면 화면에 True라고 코드를 리턴
if (st.button('press')):
    st.code('True')

# 2. 사진을 찍으면 다운로드 버튼으로 사진 다운 가능 
result = st.camera_input('Click a Snap')
if result:
    st.download_button('Download camera', result, file_name='sajin.png')
