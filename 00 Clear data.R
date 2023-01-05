# Clear data
rm(list = ls())  # Removes all objects from environment

# Clear packages
pacman::p_unload(all)  # Remove all contributed packages

# Clear plots
graphics.off()  # Clears plots, closes all graphics devices

# Clear console
cat("\014")  # Mimics ctrl+L
