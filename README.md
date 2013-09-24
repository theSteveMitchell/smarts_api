smarts_api
==========

Ruby API for Sparkling Logic SMARTS™

## Install
```ruby
  gem install smarts_api #use bundle if working in rails
```

##Usage
Create in your ruby app a config/initializers/smarts_api.rb
```ruby 
  SMARTS_CONFIG = YAML.load_file(Rails.root.join("config","sparkling_logic.yml"))[Rails.env]
  SmartsApi.configure do | config |
    config.base_uri = SMARTS_CONFIG["base_uri"]
    config.app_id = SMARTS_CONFIG["app_id"]
    config.access_key = SMARTS_CONFIG["access_key"]
    config.user_id = SMARTS_CONFIG["user_id"]
    config.pwd = SMARTS_CONFIG["pwd"]
    config.workspace_id = SMARTS_CONFIG["workspace_id"]
    config.project_id = SMARTS_CONFIG["project_id"]
  end
```

And then you'll need a yml config that looks something like 
```ruby
development: &default
 base_uri:      http://customers.sparkological.com/DecisionServer/decision-services/deployments/
 app_id:         #application ID
 access_key:     #SECRET access key
 user_id:        #the user id for the application account that has access to SMARTS
 pwd:           #account password
 workspace_id:   Top/Local #or wherever your workspace is defined.
 project_id:     #Something something project name
```

Finally you can call smarts with 
```ruby
SmartsApi.evaluate("Decide if person is cool", eval_object, logger=nil)
```

the evaluate call takes a string parameter identifying the decision to evaluate.  the eval_object is any Object, but must respond to the following methods:
```ruby
class EvalObject

  def smarts_document
    #generates a JSON document that matches the expected json format of the SMARTS project
  end
  
  def process_smarts_response(body)
    #takes a JSON document as its parameter, and processes it with whatever rules pertain to this class
  end
  
end
```


##Credits, Contributors

Created by [Steve Mitchell](https://github.com/theSteveMitchell)

Issues and contributions welcome.

##Disclaimer
This project and it's creators, contributors, detractors, fans, haters (who, by definition, are always gonna hate), users, and abusers are in no way associated with Sparkling Logic, the innovator and creator of SMARTS™.  We have no connection with Sparkling Logic, and are not responsible for any work they do.  

From http://my.sparklinglogic.com/index.php/what-it-does:

Sparkling Logic SMARTS™ is a revolutionary decision management product that provides you with an intuitive and interactive environment that dramatically lowers the learning curve to allow you to immediately start capturing and refining your decision logic.  You can combine decision logic based on business policies and expertise with decision logic revealed in your historical data- so you can narrow to the most impactful and high-performance business decision.   Collaboration is built into SMARTS so all relevant stakeholders can participate in defining and managing automated decisions.

