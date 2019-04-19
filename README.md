# Solarwinds-tools-and-queries
This repo contains queries and tools that can help a network admin with their solarwinds environment.

## Notice
Most queries and some scripts rely on a certain naming scheme or attribute to be present. This will be different for every environment. Please be aware of this and change accordingly.
An example of such a custom attribute is the DeviceCategory (='network') under NodesCustomProperties. This is how, in this instance of Solarwinds, we differentiate networking devices. You will need to find something that helps you differentiate them from Windows and/or Linux devices. An example could be Vendor, which is part of the Nodes table and therefore not a customproperty. Please refer to the online Solarwinds documentation for more info.
