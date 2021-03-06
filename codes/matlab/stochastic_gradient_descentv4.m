
startlam = 0.1;
tolerance = 0.05;
lam = startlam;
mew = 1;
grad_lam = 2*lam;
K_vec = [5;4;3;2;1];
learn_rate = 0.01;
decision_uk =0.1*ones(5,1);
energyth =10;
convergeduk = false;    
convergedlam = false;   
K = 5;
nbiterationslam = 1;
nbiterationsuk  = 1;

if K>5
    startlam = -1.15;
    mew = 0.05;
else 
    startlam = -0.9;
    mew = 0.1;    
end

sym_dur_vec = [0.3;0.5;0.4;0.4;0.5];
convergeduk = false;    
convergedlam = false;
convergedmew = false;
nbiterationslam = 1;
nbiterationsuk  = 1;
learn_rateuk =0.5;
while(convergedlam==false & convergedmew==false)
    grad_uk = (-K_vec-lam...
              + 2*(lam*decision_uk) - mew*(sum(sym_dur_vec) - 3));

    diffuk  = -learn_rateuk*(grad_uk);  
    fprintf('converge %f\n', abs(sum(diffuk))<= tolerance)
    if (abs(sum(diffuk))<= tolerance)
        convergeduk = true;
        nbiterationsuk = nbiterationsuk+1;
        fprintf('here 0 %f\n',decision_uk)
        while(convergeduk == true)
            grad_lam = -sum(decision_uk)...
            + sum(decision_uk.^2);
            diff = -learn_rate*grad_lam;
            fprintf('lam converge %f\n', abs(diff)<= tolerance)
            if (abs(diff)<= tolerance)
                converged_lam = lam;
                nbiterationslam = nbiterationslam+1;
                convergedlam = true;
                %convergeduk = false; 
                grad_mew = (sym_dur_vec(1:K,1)'*decision_uk) - 3;
                diffmew = -learn_rate*grad_mew;
                fprintf('here %f %f\n', lam, decision_uk)
                fprintf('mew converge %f\n', abs(diffmew)<=tolerance)
                if(abs(diffmew)<=tolerance)
                    convergedmew = true;
                    convergedukfin = true;
                    decision_uk = decision_uk>0.8;
                    fprintf('yea converge %f %f \n', lam, decision_uk)
                    if sum(decision_uk)>=1
                        break
                    end
                else
                  fprintf('no converge %f  \n', abs(diffmew))
                  mew = mew + diffmew;  
                end
            else
                converged_lam = 0;
                nbiterationslam = nbiterationslam+1;
                lam = lam + diff;                   
            end               
        end            
    else
        decision_uk    = decision_uk + diffuk;
        %decision_uk = decision_uk>0.8
        if ((decision_uk) <zeros(K,1))
             decision_uk = zeros(K,1);
        end
        nbiterationsuk = nbiterationsuk+1;
    end

end   
         