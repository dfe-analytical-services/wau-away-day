library(tidyverse)
animal_data<-read_csv("Data/Registered_Animals.csv")


dog_data<-animal_data %>% filter(AnimalType=="D")
cat_data<-animal_data %>% filter(AnimalType=="Cat")

Dogs<-dog_data
Cats<-cat_data

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

Dogs_name_breed<-Dogs %>% group_by(Name,PrimaryBreed) %>% count()

Dogs_name_breed<-Dogs_name_breed %>% group_by(PrimaryBreed) %>% mutate(value=max(n)) %>%
  filter(value==n) %>% arrange(desc(n)) %>% head(n=20)

Dogs_lab<-Dogs %>% filter(PrimaryBreed=="LABRAD") %>% count(PrimaryColour)

choc<-Dogs_lab %>% filter(PrimaryColour=="Chocolate") %>% select(n)

gold<-Dogs_lab %>% filter(PrimaryColour=="Gold") %>% select(n)

dog_names<-Dogs %>% group_by(Locality,Name) %>% count(Name)

dog_names<-dog_names %>% group_by(Locality) %>% mutate(value = max(n)) %>% filter(n==value) %>% 
  distinct(Locality,.keep_all=T)

dog_names$Locality<-tolower(dog_names$Locality)

shape_final_dog<-shape %>% left_join(dog_names,by=c("id"="Locality")) %>% filter(is.na(value)==F) %>% filter(id!="barringha")

dog_name<-ggplot()+geom_polygon(data=shape_final_dog,aes(x=long,y=lat,group=group,fill=(Name=="Bella")),col="white")+
  theme_void()+ggtitle("Most Popular Names Dog")
