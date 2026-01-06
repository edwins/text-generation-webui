import os
from langchain_core.messages import HumanMessage, SystemMessage

# be sure to set this env, os.environ['OPENAI_API_KEY'] 
# export OPENAI_API_KEY=x

from langchain_openai import ChatOpenAI


model="Qwen_Qwen3-4B-Instruct-2507"

chat = ChatOpenAI(
    openai_api_base = "https://149-165-173-41.js2proxy.cacao.run/v1",
    model=model
)

messages = [
    HumanMessage(content="Tell me the best spots to dine in Tucson, AZ?"),
]
print ("using model: " + model)
print(chat.invoke(messages))
