<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
	<META HTTP-EQUIV="Expires" CONTENT="-0">
        <title>QuickQuote Yea Haw!</title>
        
        <link href="css/grid.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="css/grid.js.css" type="text/css" media="screen" title="no title" charset="utf-8" />
        <link rel="stylesheet" href="css/screen/mega.css" type="text/css" media="screen" title="no title" charset="utf-8" />	
		<link rel="stylesheet" href="css/screen/buttons.css" type="text/css" media="screen" title="no title" charset="utf-8" />
		
	<%@ page import = "com.servicemesh.devops.demo.quickquote.QuoteResource" %>
	<%
		QuoteResource quote = new QuoteResource();
	    String appName =  System.getenv("APP_NAME");
	    if (appName == null) {
	    	appName = "Open Insurance";
	    }
	%>
</head>

<body>
    <div id="wrapper">
	<div id="header">
		<!--<h1><a href="#">Quick Quote 2</a></h1>-->
		<h1><%=appName%></h1>
		<div id="info">
			<h4>Welcome, User:      </h4>
			<p>
				Logged in as Admin
				<br />
				You have <a href="javascript:;">5 messages</a>
			</p>
			
			<img src="img/avatar.jpg" alt="avatar" />
		</div> <!-- #info -->
				
	</div> <!-- #header -->
	
		<div id="nav">	

			<ul class="mega-container mega-grey">
	
	
				<li class="mega mega-current">
					<a href="#" class="mega-link">Agent Home</a>	
				</li>
	
				<li class="mega">
					<a href="#" class="mega-link">Buy Insurance</a>	
				</li>
				
				<li class="mega">
					<a href="#" class="mega-link">Manage Policy</a>	
				</li>
				
				<li class="mega">
					<a href="#" class="mega-link">Claims Service</a>	
				</li>
				
				<li class="mega">
					<a href="#" class="mega-link">Know Insurance</a>	
				</li>
				
				<li class="mega">
					<a href="#" class="mega-link">Locate Agent</a>	
				</li>
		
				<li class="mega">				
					<a href="javascript:;" class="mega-tab">
						Drop-Down
					</a>
					
					<div class="mega-content mega-menu ">
						<ul>
							<li><a href="#">Sub-Item-1</a></li>
							<li><a href="#">Sub-Item-2</a></li>
							<li><a href="#">Sub-Item-3</a></li>
						</ul>
					</div>						
				</li>
		</div>
		
		<div class="portlet x12">
			<!--
			<div class="portlet-header">
				<h4>Welcome to your Open Insurance Services.</h4>
			</div>
			-->

			<div class="portlet-content">

				<div id="search-bar">
					<div id="search-left">
					<h3>Welcome to your Open Insurance Services.</h3>
					</div>
					<div id="search-right">
					<form class="form" method="post" action="">
					<span style="font-weight:bold;font-size:small">
						Search a service:
						</span>
						<input type="text" id="search_term">
						<span class="loader" style="display: none;">Loading...</span>
						<button class="btn btn-small btn-orange">Go</button>
						<br>
					</form>
					</div>
				</div>
			</div>
			
		</div>

		
    <div id="columns">
        
        <ul id="column1" class="column">
            <li class="widget color-green" id="intro">
            
                <div class="widget-head">
                    <h3>Quick Quote</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="quick-quote-th">qq</a>
                    A Business service to enable multi-channel, multi-line, pre-underwritten, quote processing capability.  This enables the Producers straigh-through-processing since it is self-sufficient for field-underwriting, thus enabling instance issuance of quote by Producers.
                    <br/>
                    <a href="#">Learn More Today!</a>
                    </p>
                    
                <form id="quickquoteform"  method="post" action="">
                <fieldset id="qq-container" class="form-border">
                <fieldset id="pt1">
				<!-- 
				<input type="radio" name="group1" value="Auto" checked>Auto<br>
				<input type="radio" name="group1" value="Home"> Home<br>
				
				-->
				
				<%= 
					quote.getInsuranceTypes().getEntity() 
				%>
				
				</fieldset>
				<fieldset id="pt2">
				
				<div class="field">
					<label for="subject">Zip: </label>
					<input type="text" name="qzip" value="" id="qq-zip" class="medium" />				
					<!--
					<span class="field_help">This is the help text for the field</span>
					<span class="field_error">This field is invalid</span>
					-->
				</div> <!-- .field -->
				<hr/>
				<ul id="qq-actions">
					<li>Create Quote</li>
					<li>Modify Quote</li>
					<li>View Quote</li>
					<li>Copy Quote</li>
					<li>Update Status</li>
				</ul>
				</fieldset>
				</fieldset>
                </div>
            </li>
            
            </form>
            <li class="widget color-red">  
                <div class="widget-head">
                    <h3>Full Quote!</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="full-quote-th"></a>
                    Process an application from the customer with referenced quote and ensures correctness and completeness of customer data.
                    </p>
                </div>
            </li>
                     <li class="widget color-blue">  
                <div class="widget-head">
                    <h3>Agency Performance</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="agency-performance-th"></a>
                    Business service to analyze performance of application intake and quote generation for a specific agency.
                </div>
            </li>
        </ul>

        <ul id="column2" class="column">
        
            <li class="widget color-yellow">  
                <div class="widget-head">
                    <h3>My Inbox</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" id="my-inbox-th" class="thumbnail"></a>
                    Business service to enable an agent to receive alerts and notifications about various events like business performance or their super cool cloud computing implementation.  Hello!</p>
                    <br/><br/>
                    <a href="#">Learn More</a>
                </div>
            </li>
            
            <li class="widget color-orange">  
                <div class="widget-head">
                    <h3>Track Quote</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="track-quote-th"></a>
                    Business service to track the status of the application/quote on the basis of the unique ID.
                    <br/>
                    <a href="#">Learn More</a>
                </div>
            </li>
            
            <li class="widget color-white">  
                <div class="widget-head">
                    <h3>Quote Performance</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="quote-performance-th"></a>
                    Business service to analyze performance of application intake and quote generation.
					<br/><a href="#">Learn More</a>
                </div>
             </li>
            <li class="widget color-white">  
                <div class="widget-head">
                    <h3>Pay Premium</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="pay-premium-th"></a>
                    Premium payment for a policy during it's lifecycle, of the amounts due from the customer or to them.
				<br/><a href="#">Learn More</a>
                </div>
             </li>
        </ul>
        
        <ul id="column3" class="column">
            <li class="widget color-orange">  
                <div class="widget-head">
                    <h3>Billing Inquiry</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" id="billing-inquiry-th" class="thumbnail"></a>
                    Billing inquiry requests from customers and producers. The billing details output includes billing history.</p>
                    <br/><br/>
                    <a href="#">Learn More</a>
                </div>
            </li>
            <li class="widget color-white">  
                <div class="widget-head">
                    <h3>Record Claim</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="record-claim-th"></a>
                    Record all elements about a claim being made by a customer or a claimant on an insurance company.
				<br/><a href="#">Learn More</a>                    
                </div>
            </li>
            <li class="widget color-white">  
                <div class="widget-head">
                    <h3>Issue Policy</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="issue-policy-th"></a>
                    Generating insurance agreement document and delivering it to the customer after confirming the premium payment plan.
				<br/><a href="#">Learn More</a>
                </div>
            </li>       
            <li class="widget color-white">  
                <div class="widget-head">
                    <h3>Maintain Policy</h3>
                </div>
                <div class="widget-content">
                    <p>
                    <a href="" class="thumbnail" id="maintain-policy-th"></a>
                    Policy modification events like endorsement, cancellation, lapse and reinstatement.
				<br/><a href="#">Learn More</a>               
                </div>
            </li>         
        </ul>
    </div> <!-- end columns -->
    	<div id="footer">
		
		<p>Copyright &copy; 2012 <a href="javascript:;">Open Insurance Company</a>. All rights reserved.</p>
		
	</div> <!-- #footer -->
</div>
    <script type="text/javascript" src="http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js"></script>
    <script type="text/javascript" src="jquery-ui-personalized-1.6rc2.min.js"></script>
    <script type="text/javascript" src="grid.js"></script>
    <script type="text/javascript" src="slate.js"></script>
</body>
</html>
