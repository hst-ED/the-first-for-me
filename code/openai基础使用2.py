from openai import OpenAI
client = OpenAI(
    base_url="https://ws-jawb9wcdwfpnli03.cn-beijing.maas.aliyuncs.com/compatible-mode/v1",
)

response = client.chat.completions.create(
    model="deepseek-v4.1-flash-1017",
    messages=[
        {"role":"system","content":"你是个python专家"},
        {"role":"assistant","content":"好的，我是编程专家"},
        {"role":"user","content":"输出1到10，用python"},
        ],
        stream=True
)
for chunk in response:
    if chunk.choices[0].delta:
       print(chunk.choices[0].delta.content,end='',flush=True)

