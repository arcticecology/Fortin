# Fortin
Fortin et al. 2015 Paleotemperature model

This repository contains the latest updated version of the Fortin et al. 2015 Paleotemperature model data. These data can also be found archived in the Polar Data Cataloguel www.polardata.ca/pdcsearch/PDCSearchDOI.jsp?doi_id=12504

This repostory will also contain the R scripts associated with running the updated model as well as performance statistics that can be used to run the Fortin et al. 2015 model as described in;

Fortin, M. C., Medeiros, A. S., Gajewski, K., Barley, E. M., Larocque-Tobler, I., Porinchu, D. F., & Wilson, S. E. (2015). Chironomid-environment relations in northern North America. Journal of paleolimnology, 54(2-3), 223-237.. 

The example of Lake KR02 (Fortin and Gajewski (2010) is provided as a means to apply the model to a reconstruction;
Fortin, M. C., & Gajewski, K. (2010). Postglacial environmental history of western Victoria Island, Canadian Arctic. Quaternary Science Reviews, 29(17-18), 2099-2110.

The cross-validated model performance statistics may differ slightly from those as described in Fortin et al. (2015) as two small corrections were made to the training-set and associated extracted CRU temperature dataset;
1) latitude and longitude data as archived in the Polar Data Catalogue were corrected due to errors in the originally published data from Larocque et al. (2006) incorporated into the original Fortin et al. (2015) model. As such, the extracted CRU temperatures differ slightly from the original dataset used. 
2) An error in the calculation of relative abundance data found in the Larocque et al. (2006), which was incorporated into the original Fortin et al. (2015) was corrected.
These corrections have improved model performance statistics from what was originally published.
