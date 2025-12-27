#import "/typ/templates/blog.typ": main
#show: main.with(
  title: "CMU Databases",
  date: "2025-06-10T21:41:05-04:00",
  tags: ("cs", "notes"),
)

*OLTP*: Online Transaction Processing, transactions are usually row-based, i.e. we dump a new person into our database, we modify a person's fields etc.

*OLAP*: Online Analytical Processing, transactions usually operate on an entire column of data, e.g. compute the mean and std of all client latencies.

Over the years, there have been various generations of database technologies. 
+ Precompute aggregations over chunks of the data (data cubes)
+ Regularly sync a row-based database with a columnar one.
+ Offload the data layer to some provider (like S3), then optimize the compute layer as much as possible.

Another trend is that we're moving away from monolithic databases, where everything, the query optimizer, the data store format, the execution engine, is designed by one company. Now, each of those pieces might be the product of some company, e.x. S3 for the data layer (can't think of many other examples).

Another trend is that before queries were being pushed to data.

Now that data is managed by an external service with a limited API, data is often pulled to the query, although with some caveats because providers may allow some degree of filtering.

*Shared-Nothing*: Each node of the Database has its own cpu, memory, etc.

*Shared-Disk*: Each node of the Database has to interface with some common API to access data resources.

Shared-Nothing has potentially higher performance because you can control precisely what data is transferred. However, it's compute layer cannot scale independently from its data layer, and scaling is also just way harder because you have to shuffle a ton of data around.

Historically, Shared-Disk was pretty terrible, but these days there exist infinitely scalable and high performance providers of such services. There are also a lot of things you can do, like caching, or writing your own libraries to bypass the page table, so on and so forth.
