# Solarwinds-tools-and-queries

This repo contains queries and tools that can help a network admin with their solarwinds environment.

## Documentation

More information can be found in the blogposts over [at my blog](https://axelrobbe.nl/).

You can freely install SWQL studio and log in on the main Solarwinds appliance to browse your database. You don't need Microsoft SQL software, special SQL skills or other servers. You can open tables to inspect the contents and help you to create proper queries.

### Notice

Most queries and some scripts rely on a certain naming scheme or attribute to be present. This will be different for every environment. Please be aware of this and change accordingly.
An example of such a custom attribute is the DeviceCategory (='network') under NodesCustomProperties. This is how, in this instance of Solarwinds, we differentiate networking devices. You will need to find something that helps you differentiate them from Windows and/or Linux devices. An example could be Vendor, which is part of the Nodes table and therefore not a customproperty. Please refer to the online Solarwinds documentation for more info.
