(function() {
    var method = {
        search: document.querySelector('.search-input'),
        delta: document.querySelector('.label-input div'),
        button: document.querySelectorAll('.button-submit'),
        span: document.querySelectorAll('.button-submit span'),
        form: document.querySelectorAll('.hero_wrap_header_form'),
        active: 'active',
        button_active: 'submit-active'
    }; 

    function add(feature) 
    {
        feature.classList.add(method.button_active);
    }

    Array.prototype.forEach.call(method.form, function(e) 
    {
        e.addEventListener('mousemove', function(e) 
        { 
            this.style.transition="1s ease";
            this.style.transform=`translate(${e.offsetX/15}px, ${e.offsetY/15}px)`;
        });
        e.removeEventListener('mousemove', function(e) 
        { 
            this.style.transition="1s ease";
            this.style.transform=`translate(0px, 0px)`;
        });

        e.removeEventListener('mouseout', function(e) 
        { 
            this.style.transition="0";
            this.style.transform=`translate(0px, 0px)`;
        });

    });
   
    Array.prototype.forEach.call(method.button, function(e) { 
        
        e.addEventListener('click', (func)=> {
            func.preventDefault();
    
            var mValue = Math.max(func.clientX, func.clientY); 
    
            var getFeature = e.getBoundingClientRect(); 

            setTimeout(function() {
                    e.lastElementChild.style.width=`110px`; 
                    e.lastElementChild.style.height = `110px`;
                    e.lastElementChild.style.transform=`translate(-50%, -50%) scale(2)`;
                    e.lastElementChild.style.opacity="0";
                    e.lastElementChild.style.transition="0.4s ease";
                    e.lastElementChild.style.zIndex="2";
            }, 30);

                e.lastElementChild.style.zIndex="-2";

                e.lastElementChild.style.left = `${func.clientX - getFeature.left}px`;
                e.lastElementChild.style.top = `${func.clientY - getFeature.top}px`;
                
                e.lastElementChild.style.transition="0s";

                e.lastElementChild.style.transform=`translate(-50%, -50%)`;
                e.lastElementChild.style.width=`0px`; 
                e.lastElementChild.style.height = `0px`;
                e.lastElementChild.style.opacity="1";
           
           
        });
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

