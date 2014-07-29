# Taxonomy Batch Processor

Simple batch processor that takes 2 xml files as input and generates html files with information on xml elements.

- *taxonomy.xml* holds the information about how elements are related to each other. 

- *destinations.xml* holds the actual text content for each element.

Each generated web page has:

- Element text content.

- Navigation that allows the user to browse to elements that are higher in the taxonomy

- Navigation that allows the user to browse to destinations that are lower in the taxonomy


## Dependencies, Test and Run

- Dependencies: `bundle install`

- Test: `rspec spec/`

- Run: `ruby tbp.rb gen -i [location input files] -o [output folder]`
