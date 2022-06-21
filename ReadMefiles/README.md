<h1>
  Castaway Frontend Documentation
</h1>
<h2> Overview</h2>
<p> Castaway is a podcast streaming app whose frontend is built with flutter which provides and intuitive and straighforward programming framework.
  You can use this app to stream your favourite podcast and listen to them at any time. The app also allows you to create your own podcasts with audio recordings
  or go live(work in progress).
</p>
<h2> Design considerations</h2>
<p> <b>Our first consideration</b> was to figure out how to stand out from other applications currently on the market. This led us to adopting a minimalist design for
our user interface. We believe that this will give us the edge over current competitors,
<br><br>
  <b>Our next consideration</b> was figuring out how to incorporate strong visuals. In this aspect we have adopted the approach of "If it's not great leave it out". Our mockup will give you a rough idea of the strong imagery we intend to impement in our app over the coming days.
  <br><br>
  <b>Our last consideration</b> was to be obvious which ties in with our minimalist ethos. We have taken extra precautions in terms of UX design to ensure a confusion free experience for the user. To allow for this all of our components refresh as necessary to provide you with up to date podcasts and podcast details.
</p>
<h2> App preview Images</h2>
<p align="center"><img width=30% height=20% src="./Castawayoptimized.gif" /></p>
<h2> User Flow Diagram </h2>
<p align="center"><img width=100% src="./CastawayDesignDiagram.png" /></p>

 ## Components and API used
  [go to API documentation →](https://github.com/yyj-02/castaway-backend/blob/main/functions/README.md)
  <br>
  <details>
  <summary><h3 style="display: inline;">In app Hot reload</h3></summary> 
  <h4>Description</h4>
  <p> A combination of API calls used to ensure that information updated on the app is displayed instantly. The collection of these API calls will be refered to as hot reload feature in the further parts of this documentation </p>
  <h4>API called</h4>
  <ul>
    <li>Get all podcasts</li>
    <li>View favourites</li>
    <li>View creations</li>
  </ul>
    </details>
    
  <details>
  <summary><h3 style="display: inline;">Login page</h3></summary> 
  <h4>Description</h4>
  <p> A simple login page which authenticates the user and loads up their information and necessary streaming data. </p>
  <h4>API called</h4>
  <ul>
    <li>Log into an account</li>
    <li>View Profile</li>
    <li>Hot reload feature</li>
  </ul>
    </details>
    
 <details>
  <summary><h3 style="display: inline;">Sign up page</h3></summary> 
  <h4>Description</h4>
  <p> A simple sign up page which creates an account, authenticates the user and loads up their information and necessary streaming data. </p>
  <h4>API called</h4>
  <ul>
    <li>Create an account</li>
    <li>View Profile</li>
    <li>Hot reload feature</li>
  </ul>
    </details>
<details>
  <summary><h3 style="display: inline;">Favorites page</h3></summary> 
  <h4>Description</h4>
  <p> A simple page that displays all the podcasts that have been marked as favourite but the user with the option to preview them </p>
  <h4>API called</h4>
  <ul>
    <li>None</li>
  </ul>
    </details>
  
  
  ### Create page
  #### Description
  #### API used
  
  ### Explore page
   #### Description
  #### API used
  
  ### Preview page
  #### Description
  #### API used
  
  ### Podcast view page
  #### Description
  #### API used
  
  ### Profile page
  #### Description
  #### API used
  
  ### View profile page
  #### Description
  #### API used
  
  ### View creations page
  #### Description
  #### API used
  
  ### Change name page
  #### Description
  #### API used
  

  
