exports.handler = async (event) => {
  console.log("✅ Lambda triggered successfully!");
  console.log("🚨 Event received:", JSON.stringify(event, null, 2));
  
  // Force log flush
  await new Promise(resolve => setTimeout(resolve, 100));
  
  return {
    statusCode: 200,
    body: JSON.stringify('Event processed')
  };
};