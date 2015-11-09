%     plot all correlations

    fCorr = figure();
    set(fCorr, 'Position', [1 1200 1200 1200]);
    
    tempIdx = flipud(rot90(reshape([1:nAnalyses^2],nAnalyses,nAnalyses)));
    remIdx = diag(tempIdx);
    
    for j = 1:nAnalyses;
        for i = 1:nAnalyses;
            
            if ((j*nAnalyses)-nAnalyses+i) > remIdx(j); % determines duplicates/identities
            
            c((j*nAnalyses)-nAnalyses+i) = subplot(nAnalyses, nAnalyses, (j*nAnalyses)-nAnalyses+i);
            scatter([escapes.(incAnalyses{j})], [escapes.(incAnalyses{i})], 1, '.')
            
            % find correlation coefficient
            
            tempMat = [[escapes.(incAnalyses{j})]', [escapes.(incAnalyses{i})]'];
            
            % remove any rows containing NaNs
            
            tempMat = tempMat(~any(isnan(tempMat),2),:);
            [tempRho, tempP] = corr(tempMat);
            rho(j,i) = tempRho(1,2);
            pVal(j,i) = tempP(1,2);
            
            % name plot
                    
            tempStr = strcat((incAnalyses{j}),' x ', (incAnalyses{i}));
            title(tempStr)
            xLimit = xlim(gca);
            yLimit = ylim(gca);
            
            rhoStr = sprintf('%1.2f', rho(j,i));
            text(xLimit(2)*.2,yLimit(2)*.8, strcat('r =', rhoStr))
            
            else
            
            rho(j,i) = NaN;
            pVal(j,i) = NaN;
                
            end
        end
    end
    
    clear tempIdx
    clear remIdx
    clear tempStr
    clear tempMat
    clear rhoStr