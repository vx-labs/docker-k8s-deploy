# K8S Deployment helper

Simple and naive script wrapped in a docker container.

To display the parameters supported by a template file, you can use
 this magic one-liner:

```
egrep -o '.*{{[^}]+}}.*' <file> | sed -e 's/.*{{\([^}]\+\)}}.*/\1/g' | sort -u
```
