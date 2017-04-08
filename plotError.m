subplot(2,2,1), plot(10:210,totalEImg)
title('reprojection error');
xlabel('side(mm)');
ylabel('error(pixel per point)');

subplot(2,2,2), plot(10:210,totalEP)
title('structure error');
xlabel('side(mm)');
ylabel('error(mm per point)');

subplot(2,2,3), plot(10:210,totalER)
title('rotation error');
xlabel('side(mm)');
ylabel('error(degree)');

subplot(2,2,4), plot(10:210,real(totalEt))
title('translation error');
xlabel('side(mm)');
ylabel('error(degree)');