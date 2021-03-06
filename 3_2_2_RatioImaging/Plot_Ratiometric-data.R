# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# R-Script for plotting ratiometric time-series data, retrieved from FIJI
# Created by Joachim Goedhart (@joachimgoedhart), first version 2020
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

require(tidyverse)

#Define a color palette that was first described by Color Universal Design (CUD): https://jfly.uni-koeln.de/color/
#See for more on color palettes: https://thenode.biologists.com/data-visualization-with-flying-colors
Okabe_Ito <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7", "#000000")


#Read the results file generated by FIJI
df_CFP <- read.csv("Results-CFP.csv")
df_YFP <- read.csv("Results-YFP.csv")

#Split the column 'Label' into three separate columns, using the colon as delimiter
df_split_CFP <- df_CFP %>% separate(Label,c("filename", "Sample","Number"),sep=':')
df_split_YFP <- df_YFP %>% separate(Label,c("filename", "Sample","Number"),sep=':')

#Rename the column with mean intensity
df_split_CFP <- df_split_CFP %>% select(Sample, Mean, Slice) %>% rename('Mean_CFP'='Mean') 
df_split_YFP <- df_split_YFP %>% select(Sample, Mean, Slice) %>% rename('Mean_YFP'='Mean')

#Unite the two dataframes
df <- full_join(df_split_YFP, df_split_CFP, by = c("Sample","Slice"))

#Normalization (here on the average of the first 5 time points)
df <- df %>% group_by(Sample) %>% mutate(norm_YFP=Mean_YFP/mean(Mean_YFP[1:5]),
                                         norm_CFP=Mean_CFP/mean(Mean_CFP[1:5]))

#Calculate ratio
df <- df %>% mutate(ratio=norm_YFP/norm_CFP)

#Add the time information based on a (known) interval (here we use 2 seconds):
df <- df %>% mutate(Time=Slice*2)

#Save the processed data as a new csv file
write.csv(df, 'Normalized_data.csv')

#Plot - By turning a line of code into a comment with a '#', the effect of different functions can be discovered
#
ggplot(data=df, aes(x=Time, y=ratio, group=Sample, color=Sample))+
  geom_line(size=1) +
  geom_point(size=2) +
  scale_color_manual(values=Okabe_Ito) +
  annotate("rect",xmin=25,xmax=175,ymin=-Inf,ymax=Inf,alpha=0.1,fill="black")+
  annotate("text", x=100, y=6, alpha=1, size = 8, label='histamine') +
  theme_light(base_size = 16) +
  labs(x = "Time [s]", y = "Normalized Ratio") +
  labs(title = "Calcium oscillations induced by histamine") +
  theme(plot.title = element_text(size=24)) +
  theme(panel.grid = element_blank()) +
  # theme(legend.position="none") +
  # facet_wrap(~Sample) +
  coord_cartesian(xlim=c(0,220),ylim=c(1,6)) +
  NULL #Do not remove or uncomment this line

ggsave(
  'Ratio-plot.png',
  plot = last_plot(),
  device = 'png',
  width=21,
  height=16,
  units = 'cm',
  dpi = 300
)









