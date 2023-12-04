# Introduction

This terraform is an initial implementation to provision text-generation-webui in an OpenStack cloud, namely with CACAO on Jetstream2. It utilizes cacao's base template called single-image-app-proxy. The app-proxy is a simple nginx reverse proxy that can be used to protect an application with basic authentication or api tokens. 