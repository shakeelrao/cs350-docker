#!/bin/bash

docker pull 3uclid/cs350:1.0
mkdir cs350-os161
cd cs350-os161
curl -L http://www.student.cs.uwaterloo.ca/~cs350/os161_repository/os161.tar.gz | tar xz
