########### merge all simulations to calculate type 1 error
rm(list=ls())
setwd("/data/shengf2/simu_mtop/power/result_six1")


#p_acat

files = list.files(pattern = ".Rdata")
library(gtools)
files <- mixedsort(files)
nfiles = length(files)
print(nfiles)

# strsplit(files[1],"0.25_",".Rdata")
# str_extract(files[1], "(?<=0.25:)[0-9]*")



# num.sort <- as.numeric(gsub("[^\\d]+", "\\1", files, perl = TRUE))
# nop = as.numeric(gsub("[A-z \\.\\(\\)]","",files))
# library(stringr)
# nop = as.numeric(str_extract(files, "(?<=0.25_:?)\\d+"))
# a1 = 1:2000
# df1 = setdiff(a1,nop)
# df1

load(files[1])
n1 = nrow(result[[1]])
n2 = ncol(result[[1]])

# index = NULL
# for(i in 1:nfiles){
#   res <- try(load(files[i]))
#   if(inherits(res, "try-error")){
#     #error handling code, maybe just skip this iteration using
#     index = c(index,i)
#     next
#   }
#   #rest of iteration for case of no error
#   if (i %%100==0){
#     cat("File",i,"is loaded!!\n")
#   }
# }
# files = files[-index]
# nfiles = length(files)

# result <- list(p_mglobal_result,p_standard,p_poly,p_topo)

#the result matrix contains 9 columns (2 scenarios* 3 sample*sizes)
#the column 1-3 represents scenario one (s==1), column 1-3 represents sample size 25000, 50000, 100000
#the column 4-6 represents scenario two (s==2), column 4-6 represents sample size 25000, 50000, 100000
#the column 7-9 represents scenario three (s==3), column 7-9 represents sample size 25000, 50000, 100000
#each row of the results matrix contains a simulation replicate
# nfiles = 1000
p_mglobal_result = matrix(0, n1*nfiles, n2)
p_standard = matrix(0, n1*nfiles, n2)
p_subtypes = matrix(0, n1*nfiles, n2)
p_topo = matrix(0, n1*nfiles, n2)




for(i in 1:nfiles){
    a <- n1*(i-1)+1
    b <- n1*i
    vec <- a:b
    
    load(files[i])
    p_subtypes[vec,] = result[[1]]
    p_topo[vec,] = result[[2]]
    
    rm(result)
    
    if (i %%100==0){
      cat("File",i,"is loaded!!\n")
    }
}


## 4*9 matrix
# res1 = colMeans(p_mglobal_result<=5E-08)
# res2 = colMeans(p_standard<=5E-08)
res3 = colMeans(p_subtypes<=5E-08,na.rm = T)
res4 = colMeans(p_topo<=5E-08) 
nfiles


# res = rbind(res1,res2,res3,res4)
res = rbind(res3,res4)
row.names(res) = c("subtypes","topo")
res
write.csv(res,paste0("../results_test_",nfiles,"_six.csv"), row.names =TRUE)
