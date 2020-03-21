(function() {
    var method = {
        search: document.querySelector('.search-input'),
        delta: document.querySelector('.label-input div'),
        active: 'active'
    }; 
    
 
    if ((typeof method.search.value !== 'string')) 
    {
        String(method.search.value); 
    }
    

    function active(feature) 
    {
        feature.classList.add(method.active);
    }

    function remove(feature) 
    {
        feature.classList.remove(method.active);
    }

    method.search.addEventListener('keydown', ()=> {
        if (method.search.value.length > 0) 
        {
            active(method.delta)
        } else 
        {
           
            remove(method.delta);
        }
    
    });

    method.search.addEventListener('keyup', ()=> {
        if (method.search.value.length > 0) 
        {
           
            active(method.delta)
        } else 
        {
           
            remove(method.delta);
        }
    
    });

    method.search.removeEventListener('keyup', ()=> {
        if (method.search.value.length > 0) 
        {
          
            active(method.delta)
        } else 
        {
         
            remove(method.delta);
        }
      
    });

    method.search.removeEventListener('keydown', ()=> {
        if (method.search.value.length > 0) 
        {
           
            active(method.delta)
        } else 
        {
           
            remove(method.delta);
        }
      
    });


}).call(this);

