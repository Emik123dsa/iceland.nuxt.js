(function() {
    var method = {
        search: document.querySelector('.search-input'),
        delta: document.querySelector('.label-input div'),
        button: document.querySelector('.button-submit'),
        span: document.querySelector('.button-submit span'),
        active: 'active',
        button_active: 'submit-active'
    }; 

    function add(feature) 
    {
        feature.classList.add(method.button_active);
    }

    method.button.addEventListener('click', (e)=> {
        e.preventDefault();

        var mValue = Math.max(method.button.clientX, method.button.clientY); 

        var getFeature = method.button.getBoundingClientRect();
        setTimeout(function() {
            method.span.style.width=`110px`; 
            method.span.style.height = `110px`;
            method.span.style.transform=`translate(-50%, -50%) scale(2)`;
            method.span.style.opacity="0";
            method.span.style.transition="0.4s ease";
        }, 100);

        method.span.style.left = `${e.clientX - getFeature.left}px`;
        method.span.style.top = `${e.clientY - getFeature.top}px`;
        method.span.style.transition="0s";
        method.span.style.transform=`translate(-50%, -50%)`;
        method.span.style.width=`0px`; 
        method.span.style.height = `0px`;

        method.span.style.opacity="1";
    });

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

