library(tidyverse)
animal_data<-read_csv("Data/Registered_Animals.csv")


dog_data<-animal_data %>% filter(AnimalType=="D")
cat_data<-animal_data %>% filter(AnimalType=="Cat")

dog_data<-dog_data %>% group_by(Locality,PrimaryBreed) %>% count(PrimaryBreed)

dog_data<-dog_data %>% group_by(Locality) %>% mutate(value = max(n)) %>% filter(n==value) %>% 
  distinct(Locality,.keep_all=T)

cat_data<-cat_data %>% group_by(Locality,PrimaryBreed) %>% count(PrimaryBreed)

cat_data<-cat_data %>% group_by(Locality) %>% mutate(value = max(n)) %>% filter(n==value) %>% 
  distinct(Locality,.keep_all=T)

library(rgdal)

shape<-readOGR("Data/SSC_2016_QSLD")

library(ggplot2)

shape<-fortify(shape,region="SSC_NAME16")

#shape<-read_csv("Data/SSC_2016_AUST.csv")

dog_data$Locality<-tolower(dog_data$Locality)
cat_data$Locality<-tolower(cat_data$Locality)
shape$id<-tolower(shape$id)

shape_final_dog<-shape %>% left_join(dog_data,by=c("id"="Locality")) %>% filter(is.na(value)==F) %>% filter(id!="barringha")

dog_breed<-ggplot()+geom_polygon(data=shape_final_dog,aes(x=long,y=lat,group=group,fill=PrimaryBreed),col="white")+
  theme_void()+ggtitle("Most Popular Breeds Dog")

shape_final_cat<-shape %>% left_join(cat_data,by=c("id"="Locality")) %>% filter(is.na(value)==F) %>% filter(id!="barringha")

cat_breed<-ggplot()+geom_polygon(data=shape_final_cat,aes(x=long,y=lat,group=group,fill=PrimaryBreed),col="white")+
  theme_void()+ggtitle("Most Popular Breeds Cat")
