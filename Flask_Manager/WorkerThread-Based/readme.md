    

*Moving to spawning R as worker threads, chopping out Shiny:*    

- upload / download, UI, http GET / POST, everything managed from Flask
- templating is done with pug/jade
- no port limits- scheduling works fine with Redis DB but may not be necessary 
    
*** Test with: ***

```bash
flask run 
```

