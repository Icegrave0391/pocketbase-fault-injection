#!/usr/bin/env node
// Run with: node extract_app_logs_simple.js

import PocketBase from 'pocketbase';

async function extractAllLogs() {
    const pb = new PocketBase('http://127.0.0.1:8090');
    
    try {
        // Admin login
        await pb.collection("_superusers").authWithPassword('test@gmail.com', '1234567890');
        
        // Get all logs
        let allLogs = [];
        let currentPage = 1;
        const perPage = 500;
        let hasMore = true;

        while (hasMore) {
            const pageResult = await pb.logs.getList(currentPage, perPage, {
                sort: '-created'
            });
            
            allLogs = allLogs.concat(pageResult.items);
            
            // Check if there are more pages
            hasMore = pageResult.items.length === perPage;
            currentPage++;
            
            // Safety measure: prevent infinite loop
            if (currentPage > 1000) {
                break;
            }
        }

        // Print all logs to console
        allLogs.forEach((log) => {
            const timestamp = log.created;
            const method = log.data?.method || 'N/A';
            const url = log.data?.url || 'N/A';
            const status = log.data?.status || 'N/A';
            const userAgent = log.data?.userAgent || '';
            const ip = log.data?.userIp || 'N/A';
            const execTime = log.data?.execTime || 'N/A';
            const error = log.data?.error;
            const details = log.data?.details;

            let msg = `[${timestamp}] ${ip} "${method} ${url}" STATUS=${status} Time=${execTime}ms "${userAgent}"`;
            if (error) {
                msg += `\n  error: ${JSON.stringify(error)}`;
            }
            if (details) {
                msg += `\n  details: ${JSON.stringify(details)}`;
            }
            console.log(msg);
        });

        return allLogs;

    } catch (error) {
        if (error.status === 401) {
            console.error('Authentication failed');
        } else if (error.status === 404) {
            console.error('API endpoint not found');
        } else {
            console.error('Error:', error.data || error.message);
        }
        
        throw error;
    }
}

// Run script
extractAllLogs()
    .catch((error) => {
        process.exit(1);
    });
